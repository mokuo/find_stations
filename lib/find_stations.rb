# frozen_string_literal: true

require "bundler/setup"
require "csv"
require "pry" # binding.pry

require_relative "./find_stations/station"
require_relative "./find_stations/train_route_search_engine"
require_relative "./find_stations/train_routes_factory"

module FindStations
  START_STATION_NAME = ARGV[0]

  raise ArgumentError, "引数に駅名を指定してください。（例）東京" if START_STATION_NAME.nil?

  puts "start!"

  search_engine = TrainRouteSearchEngine.new
  result_train_routes = []

  # START_STATION_NAME を通る路線一覧を取得
  search_result = search_engine.search_train_lines(START_STATION_NAME)
  # 各路線を通る駅一覧を取得
  search_results = search_result.stations.map { |station| search_engine.search_train_stations(station.line) }

  # 経路情報を作成
  train_routes = TrainRoutesFactory.create(START_STATION_NAME, search_results)
  result_train_routes += train_routes

  # １つ目の路線の各駅を通る路線一覧を取得
  search_results = train_routes.map do |train_route|
    search_engine.search_train_lines(train_route.stations.first.name, train_route)
  end

  # ２つ目の路線を通る駅一覧を取得
  search_results = search_results.flat_map do |sr|
    sr.stations.map { |station| search_engine.search_train_stations(station.line, search_result.train_route) }
  end

  # 経路情報を作成
  train_routes = TrainRoutesFactory.create(START_STATION_NAME, search_results)
  result_train_routes += train_routes

  CSV.open("tmp/stations.csv", "wb") do |csv|
    csv << %w[出発駅 路線１ 駅１ 路線２ 駅２]

    result_train_routes.each do |train_route|
      first_station = train_route.stations[0]
      second_station = train_route.stations[1]
      csv << [
        train_route.start_station_name,
        first_station.line,
        first_station.name,
        second_station&.line,
        second_station&.name
      ]
    end
  end

  puts "...finish!"
end

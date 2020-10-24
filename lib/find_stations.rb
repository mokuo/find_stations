# frozen_string_literal: true

require "bundler/setup"
require "csv"
# require "pry" # binding.pry

require_relative "./find_stations/station"
require_relative "./find_stations/train_route"
require_relative "./find_stations/heart_rails/express_api_client"

module FindStations
  START_STATION_NAME = ARGV[0]

  raise ArgumentError, "引数に駅名を指定してください。（例）東京" if START_STATION_NAME.nil?

  puts "start!"

  client = HeartRails::ExpressApiClient.new
  result_train_routes = []

  line_stations = client.get_stations_by(station_name: START_STATION_NAME)
  stations = line_stations.flat_map { |station| client.get_stations_by(train_line_name: station.line) }
  train_routes = stations.map { |station| TrainRoute.new(START_STATION_NAME).append_station(station) }

  result_train_routes += train_routes

  train_route_and_line_stations_list = train_routes.map do |train_route|
    line_stations = client.get_stations_by(station_name: train_route.stations.first.name)
    { train_route: train_route, line_stations: line_stations }
  end

  train_route_and_stations_list = train_route_and_line_stations_list.map do |train_route_and_line_stations|
    train_route = train_route_and_line_stations[:train_route]
    line_stations = train_route_and_line_stations[:line_stations]

    stations = line_stations.flat_map { |station| client.get_stations_by(train_line_name: station.line) }
    { train_route: train_route, stations: stations }
  end

  train_routes = train_route_and_stations_list.flat_map do |train_route_and_stations|
    train_route = train_route_and_stations[:train_route]
    stations = train_route_and_stations[:stations]

    stations.map { |station| train_route.append_station(station) }
  end

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

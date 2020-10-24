# frozen_string_literal: true

require "bundler/setup"
require "uri"
require "faraday"
require "json"
require "csv"
# require "pry" # binding.pry

# ref: http://express.heartrails.com/api.html
class Station
  # ex) {:name=>"北千住", :prefecture=>"東京都", :line=>"東京メトロ千代田線",
  #      :x=>139.804276, :y=>35.748916, :postal=>"1200026", :prev=>"綾瀬", :next=>"町屋"}
  attr_reader :name, :prefecture, :line, :x, :y, :postal, :prev, :next

  def initialize(hash)
    @name = hash[:name]
    @prefecture = hash[:prefecture]
    @line = hash[:line]
    @x = hash[:x]
    @y = hash[:y]
    @postal = hash[:postal]
    @prev = hash[:prev]
    @next = hash[:next]
  end
end

class TrainRoute
  attr_reader :start_station_name, :stations

  def initialize(start_station_name, stations = [])
    @start_station_name = start_station_name
    @stations = stations
  end

  def append_station(station)
    new_stations = stations + [station]
    self.class.new(start_station_name, new_stations)
  end
end

def get_stations_by_name(station_name)
  sleep 0.01
  print "\rhttp://express.heartrails.com/api/json?method=getStations&name=#{station_name}"

  name = URI.encode_www_form_component(station_name)
  res = Faraday.get "http://express.heartrails.com/api/json?method=getStations&name=#{name}"
  JSON.parse(res.body, symbolize_names: true)[:response][:station].map { |s| Station.new(s) }
end

def get_stations_by_line(train_line_name)
  sleep 0.01
  print "\rhttp://express.heartrails.com/api/json?method=getStations&line=#{train_line_name}"

  line = URI.encode_www_form_component(train_line_name)
  res = Faraday.get "http://express.heartrails.com/api/json?method=getStations&line=#{line}"
  JSON.parse(res.body, symbolize_names: true)[:response][:station].map { |s| Station.new(s) }
end

START_STATION_NAME = ARGV[0]

raise ArgumentError, "引数に駅名を指定してください。（例）東京" if START_STATION_NAME.nil?

puts "start!"

result_train_routes = []

line_stations = get_stations_by_name(START_STATION_NAME)
stations = line_stations.flat_map { |station| get_stations_by_line(station.line) }
train_routes = stations.map { |station| TrainRoute.new(START_STATION_NAME).append_station(station) }

result_train_routes += train_routes

train_route_and_line_stations_list = train_routes.map do |train_route|
  line_stations = get_stations_by_name(train_route.stations.first.name)
  { train_route: train_route, line_stations: line_stations }
end

train_route_and_stations_list = train_route_and_line_stations_list.map do |train_route_and_line_stations|
  train_route = train_route_and_line_stations[:train_route]
  line_stations = train_route_and_line_stations[:line_stations]

  stations = line_stations.flat_map { |station| get_stations_by_line(station.line) }
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

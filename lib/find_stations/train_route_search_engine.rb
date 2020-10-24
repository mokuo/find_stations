# frozen_string_literal: true

require_relative "./heart_rails/express_api_client"
# require "pry" # binding.pry

module FindStations
  class SearchResult
    attr_reader :train_route, :stations

    def initialize(train_route, stations)
      @train_route = train_route
      @stations = stations
    end
  end

  class TrainRouteSearchEngine
    def initialize(client = HeartRails::ExpressApiClient.new)
      @client = client
    end

    def search_train_lines(station_name, train_route = nil)
      stations = @client.get_stations_by(station_name: station_name)
      SearchResult.new(train_route, stations)
    end

    def search_train_stations(train_line_name, train_route = nil)
      stations = @client.get_stations_by(train_line_name: train_line_name)
      SearchResult.new(train_route, stations)
    end
  end
end

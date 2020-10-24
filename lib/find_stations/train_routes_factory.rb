# frozen_string_literal: true

require_relative "./train_route"

module FindStations
  class TrainRoutesFactory
    def self.create(start_station_name, search_results)
      new.create(start_station_name, search_results)
    end

    def create(start_station_name, search_results)
      search_results.flat_map do |search_result|
        train_route = search_result.train_route
        if train_route.nil?
          initialize_train_route(start_station_name, search_result)
        else
          append_station(search_result)
        end
      end
    end

    private

    def initialize_train_route(start_station_name, search_result)
      search_result.stations.map { |station| TrainRoute.new(start_station_name).append_station(station) }
    end

    def append_station(search_result)
      search_result.stations.map { |station| train_route.append_station(station) }
    end
  end
end

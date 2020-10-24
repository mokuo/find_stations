# frozen_string_literal: true

module FindStations
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
end

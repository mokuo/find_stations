# frozen_string_literal: true

require_relative "./aggregate"

module Rakusta
  class Line
    include Aggregate

    def initialize(stations)
      @stations = stations
    end

    def iterator
      LineIterator.new(self)
    end

    def find_station(name)
      @stations.find { |station| station.name == name }
    end
  end
end

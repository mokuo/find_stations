# frozen_string_literal: true

require_relative "./iterator"

module Rakusta
  class LineIterator
    include Iterator

    def initialize(line, current_station = nil)
      @line = line
      @current_station = current_station
    end

    def next?
      @current_station.nil? || @current_station.next?
    end

    def next
      @current_station = @line.find_station(@current_station.next)
    end

    def prev?
      @current_station.nil? || @current_station.prev?
    end

    def prev
      @current_station = @line.find_station(@current_station.prev)
    end
  end
end

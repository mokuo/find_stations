# frozen_string_literal: true

require "bundler/setup"
require "uri"
require "faraday"
require "json"
require_relative "../station"

module FindStations
  module HeartRails
    class ExpressApiClient
      def get_stations_by(station_name: nil, train_line_name: nil)
        raise ArgumentError, "station_name と train_line はどちらかしか指定できません" if !station_name.nil? && !train_line_name.nil?

        if !station_name.nil?
          get_stations_by_name(station_name)
        elsif !train_line_name.nil?
          get_stations_by_line(train_line_name)
        else
          raise ArgumentError, "station_name か train_line のどちらかを指定してください"
        end
      end

      private

      def get_stations_by_name(station_name)
        get_stations("name", station_name)
      end

      def get_stations_by_line(train_line_name)
        get_stations("line", train_line_name)
      end

      def get_stations(param, value)
        print "."
        sleep 0.01

        encoded_value = URI.encode_www_form_component(value)
        res = Faraday.get "http://express.heartrails.com/api/json?method=getStations&#{param}=#{encoded_value}"
        JSON.parse(res.body, symbolize_names: true)[:response][:station].map { |s| Station.new(s) }
      end
    end
  end
end

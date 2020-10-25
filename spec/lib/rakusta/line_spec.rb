# frozen_string_literal: true

RSpec.describe Rakusta::Line do
  describe "#find_station" do
    it "渡された名前の Station を返す" do
      station1 = Rakusta::Station.new(name: "品川")
      station2 = Rakusta::Station.new(name: "大崎")
      line = described_class.new([station1, station2])
      expect(line.find_station("品川")).to eq station1
    end
  end
end

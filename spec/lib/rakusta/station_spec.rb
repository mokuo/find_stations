# frozen_string_literal: true

RSpec.describe Rakusta::Station do
  describe "#prev?" do
    where(:name, :line, :prev, :_next, :result) do
      [
        ["品川", "JR山手線", nil, "大崎", false],
        ["大崎", "JR山手線", "品川", "五反田", true]
      ]
    end

    with_them do
      it do
        station = described_class.new(name: name, line: line, prev: prev, next: _next)
        expect(station.prev?).to eq result
      end
    end
  end

  describe "#next?" do
    where(:name, :line, :prev, :_next, :result) do
      [
        ["田町", "JR山手線", "品川", "高輪ゲートウェイ", true],
        ["高輪ゲートウェイ", "JR山手線", "田町", nil, false]
      ]
    end

    with_them do
      it do
        station = described_class.new(name: name, line: line, prev: prev, next: _next)
        expect(station.next?).to eq result
      end
    end
  end
end

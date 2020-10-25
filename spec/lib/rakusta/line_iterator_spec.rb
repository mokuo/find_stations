# frozen_string_literal: true

RSpec.describe Rakusta::LineIterator do
  describe "next?" do
    context "１駅目" do
      it do
        iterator = described_class.new(Rakusta::Line.new([]))
        expect(iterator.next?).to eq true
      end
    end

    context "２駅目以降" do
      where(:_next, :result) do
        [
          ["高輪ゲートウェイ", true],
          [nil, false]
        ]
      end

      with_them do
        it do
          station = Rakusta::Station.new(next: _next)
          iterator = described_class.new(Rakusta::Line.new([]), station)
          expect(iterator.next?).to eq result
        end
      end
    end
  end

  describe "prev?" do
    context "１駅目" do
      it do
        iterator = described_class.new(Rakusta::Line.new([]))
        expect(iterator.prev?).to eq true
      end
    end

    context "２駅目以降" do
      where(:prev, :result) do
        [
          ["高輪ゲートウェイ", true],
          [nil, false]
        ]
      end

      with_them do
        it do
          station = Rakusta::Station.new(prev: prev)
          iterator = described_class.new(Rakusta::Line.new([]), station)
          expect(iterator.prev?).to eq result
        end
      end
    end
  end
end

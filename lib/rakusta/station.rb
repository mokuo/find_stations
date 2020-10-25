# frozen_string_literal: true

module Rakusta
  class Station
    # ex) {:name=>"北千住", :prefecture=>"東京都", :line=>"東京メトロ千代田線",
    #      :x=>139.804276, :y=>35.748916, :postal=>"1200026", :prev=>"綾瀬", :next=>"町屋"}
    attr_reader :name, :line, :prev, :_next

    def initialize(hash)
      @name = hash[:name]
      @line = hash[:line]
      @prev = hash[:prev]
      @_next = hash[:next]
    end

    def prev?
      !prev.nil?
    end

    def next?
      !_next.nil?
    end
  end
end

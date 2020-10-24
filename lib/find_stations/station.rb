# frozen_string_literal: true

module FindStations
  # ref: http://express.heartrails.com/api.html
  class Station
    # ex) {:name=>"北千住", :prefecture=>"東京都", :line=>"東京メトロ千代田線",
    #      :x=>139.804276, :y=>35.748916, :postal=>"1200026", :prev=>"綾瀬", :next=>"町屋"}
    attr_reader :name, :prefecture, :line, :x, :y, :postal, :prev, :next

    def initialize(hash)
      @name = hash[:name]
      @prefecture = hash[:prefecture]
      @line = hash[:line]
      @x = hash[:x]
      @y = hash[:y]
      @postal = hash[:postal]
      @prev = hash[:prev]
      @next = hash[:next]
    end
  end
end

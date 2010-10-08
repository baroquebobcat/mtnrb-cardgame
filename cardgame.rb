module Enumerable
  def sum
    unless block_given?
      inject(0){|sum, i| sum + i }
    else
      inject(0){|sum, i| sum + yield(i) }
    end
  end
end

module MountainRB

  module CardGame
    class Hand

      attr_accessor :cards, :role
 
      def initialize role, cards
        raise TooManyCards.new unless cards.size <=6
        @role = role
        @cards = cards
      end

      def resource_score
        if find_cards('Horse').empty?
          0
        else
          find_cards('Cattle').sum{|c| c.value}
        end
      end
      def land_score
        find_cards('Plains').sum{|c| c.value } +
        find_cards('Mountain').sum{|c| c.value / 2 }
      end
      def tool_score
        1
      end
      def beast_score
        if find_cards('Mountain').empty?
          find_cards('Horse').sum{|c| c.value}
        else
          find_cards('Horse').sum{|c| c.value / 2}
        end
      end

      def score
        resource_score + land_score + tool_score + beast_score
      end

      def find_cards name
        cards.select {|c| c.name == name}
      end
    end

    class Card
      attr_accessor :name, :value
      def initialize name, value
        @name = name
        @value =  value
      end
    end
    TooManyCards = Class.new StandardError 
  end
end

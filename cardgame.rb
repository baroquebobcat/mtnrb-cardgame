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
        case role
        when :cowboy
          if find_cards('Horse').empty?
            0
          else
            find_cards('Cattle').sum{|c| c.value }
          end
        else
          find_cards('Ore Vein').sum{|c| c.value }
        end
      end

      def land_score
        land_scoring = case role
               when :cowboy
                 {:half => 'Mountain',
                  :full => 'Plains'}
               else
                  {:half => 'Forest',
                   :full => 'Mountain'}
               end
        find_cards(land_scoring[:full]).sum{|c| c.value } +
        find_cards(land_scoring[:half]).sum{|c| c.value / 2 }
      end

      def tool_score
        tool = case role
               when :cowboy
                 'Lasso'
               else
                 'Pickaxe'
               end
        highest_card(tool).value
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
      def highest_card name
        find_cards(name).sort_by {|c| c.value }.last
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

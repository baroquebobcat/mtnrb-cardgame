module MountainRB

  module CardGame
    class Hand
      attr_accessor :cards

      def initialize cards
        @cards = cards
      end
    end
    class Card
      attr_accessor :name, :type, :value
      def initialize name, value
        @name = name
        @value =  value
      end
    end
  end
end
describe MountainRB::CardGame::Hand do
  it "takes a list of 6 cards" do
    MountainRB::CardGame::Hand.new 6.times.map{ MountainRB::CardGame::Card.new 'foo',1}
  end
end

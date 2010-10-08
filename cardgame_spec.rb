module MountainRB

  module CardGame
    class Hand
      attr_accessor :cards

      def initialize cards
        raise TooManyCards.new unless cards.size <=6
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
    TooManyCards = Class.new StandardError 
  end
end

 include MountainRB::CardGame
describe MountainRB::CardGame::Hand do
  it "takes a list of 6 cards" do
    Hand.new 6.times.map{ Card.new 'foo',1}
  end
  it "complains when there are more than 6 cards" do
    lambda {
      Hand.new 7.times.map{ Card.new 'foo',1}
    }.should raise_error TooManyCards
  end
end

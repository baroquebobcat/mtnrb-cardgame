module MountainRB

  module CardGame
    class Hand
      attr_accessor :cards, :role

      def initialize role, cards
        raise TooManyCards.new unless cards.size <=6
        @cards = cards
        @role = role
      end

      def resource_score
        3
      end
      def land_score
        2
      end
      def tool_score
        1
      end
      def beast_score
        1
      end
      def score
        7
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
  it "takes a role and a list of 6 cards" do
    Hand.new :cowboy, 6.times.map{ Card.new 'foo',1}
  end

  it "complains when there are more than 6 cards" do
    lambda {
      Hand.new :cowboy, 7.times.map{ Card.new 'foo',1}
    }.should raise_error TooManyCards
  end

  context "cowboy example" do
    let(:cards) { [   Card.new('Cattle', 3),
                      Card.new('Mountain', 5),
                      Card.new('Lasso', 1),
                      Card.new('Horse', 2)]
    }
    let(:hand) { Hand.new :cowboy, cards }
    it { hand.resource_score.should == 3 }
    it { hand.land_score.should == 2 }
    it { hand.tool_score.should == 1 }
    it { hand.beast_score.should == 1 }
    it { hand.score.should == 7 }
  end
end

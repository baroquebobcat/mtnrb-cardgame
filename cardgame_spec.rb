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

  context "cowboy example 1 " do
    let(:cards) { [   Card.new('Cattle', 3),
                      Card.new('Mountain', 5),
                      Card.new('Lasso', 1),
                      Card.new('Horse', 2)
                  ] }
    let(:hand) { Hand.new :cowboy, cards }

    it { hand.resource_score.should == 3 }
    it { hand.land_score.should == 2 }
    it { hand.tool_score.should == 1 }
    it { hand.beast_score.should == 1 }
    it { hand.score.should == 7 }
  end

  context "cowboy with only plains" do
    let(:cards) { [ Card.new('Plains', 5) ] }
    let(:hand) { Hand.new :cowboy, cards }
    it { hand.land_score.should == 5 }
  end

  context "cowboy with only forest" do
    let(:cards) { [ Card.new('Forest', 5) ] }
    let(:hand) { Hand.new :cowboy, cards }
    it { hand.land_score.should == 0 }
  end
  context "cowboy with different cattle 2 " do
    let(:cards) { [   Card.new('Cattle', 8),
                      Card.new('Mountain', 5),
                      Card.new('Lasso', 1),
                      Card.new('Horse', 2)
                  ] }
    let(:hand) { Hand.new :cowboy, cards }

    it { hand.resource_score.should == 8 }
  end

  context "cowboy with no horse" do
    let(:cards) { [   Card.new('Cattle', 8),
                      Card.new('Mountain', 5),
                      Card.new('Lasso', 1)
                  ] }
    let(:hand) { Hand.new :cowboy, cards }

    it { hand.resource_score.should == 0 }
    it { hand.beast_score.should == 0 }
  end

  context "prospector example" do
    let(:cards) { [ Card.new('Ore Vein', 1),
                    Card.new('Ore Vein', 5),
                    Card.new('Mountain', 3),
                    Card.new('Pickaxe', 4),
                    Card.new('Burro', 2)
                  ] }
    let(:hand) { Hand.new :prospector, cards }

#    it { hand.resource_score.should == 6 }
#    it { hand.land_score.should == 2 }
#    it { hand.tool_score.should == 1 }
#    it { hand.beast_score.should == 1 }
#    it { hand.score.should == 7 }
  end
end

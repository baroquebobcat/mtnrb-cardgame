require File.dirname(__FILE__) + '/cardgame'
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

  describe "#beast_score" do
    context "with a horse and a mountain" do
      let(:hand) { Hand.new :irrelevant, [Card.new('Horse', 2),Card.new('Mountain', 2)] }
      it { hand.beast_score.should == 1 } 
    end

    context "with a burro and a mountain" do
      let(:hand) { Hand.new :irrelevant, [Card.new('Burro', 2),Card.new('Mountain', 2)] }
      it { hand.beast_score.should == 4 } 
    end

    context "with an ox and a homesteader" do
      let(:hand) { Hand.new :homesteader, [Card.new('Burro', 2),Card.new('Mountain', 2)] }
      it { hand.beast_score.should == 4 } 
    end

  end

  context "role as cowboy" do
    let (:role) {:cowboy}
    
    context "example 1 " do
      let(:cards) { [ Card.new('Cattle', 3),
                      Card.new('Mountain', 5),
                      Card.new('Lasso', 1),
                      Card.new('Horse', 2) ] }
      let(:hand) { Hand.new role, cards }
      
      it { hand.resource_score.should == 3 }
      it { hand.land_score.should == 2 }
      it { hand.tool_score.should == 1 }
      it { hand.beast_score.should == 1 }
      it { hand.score.should == 7 }
    end

    context "with only plains" do
      let(:cards) { [ Card.new('Plains', 5) ] }
      let(:hand) { Hand.new role, cards }
      it { hand.land_score.should == 5 }
    end
    
    context "with only mountains" do
      let(:hand) { Hand.new role, [ Card.new('Mountain', 5) ] }
      it { hand.land_score.should == 2 }
    end
    
    context "with only forest" do
      let(:hand) { Hand.new role, [ Card.new('Forest', 5) ] }
      it { hand.land_score.should == 0 }
    end
    
    context "cowboy with different cattle" do
      let(:hand) { Hand.new role, [ Card.new('Horse', 8), Card.new('Cattle', 8) ] }
      
      it { hand.resource_score.should == 8 }
    end
    
    context "with two lassos" do
      let(:hand) { Hand.new role, [ Card.new('Lasso', 1), Card.new('Lasso', 8) ] }
      
      it { hand.tool_score.should == 8 }
    end

    context "with no horse" do
      let(:cards) { [   Card.new('Cattle', 8),
                      Card.new('Mountain', 5),
                      Card.new('Lasso', 1)
                  ] }
      let(:hand) { Hand.new role, cards }
      
      it { hand.resource_score.should == 0 }
      it { hand.beast_score.should == 0 }
    end
  end

  context "with role prospector" do
    let(:role){:prospector}
    context "example" do
      let(:cards) { [ Card.new('Ore Vein', 1),
                      Card.new('Ore Vein', 5),
                      Card.new('Mountain', 3),
                      Card.new('Pickaxe', 4),
                    Card.new('Burro', 2)
                    ] }
      let(:hand) { Hand.new role, cards }
      
      it { hand.resource_score.should == 6 }
      it { hand.land_score.should == 3 }
      it { hand.tool_score.should == 4 }
      it { hand.beast_score.should == 4 }
      it { hand.score.should == 17 }
    end

    context "with only mountains" do
      let(:hand) { Hand.new role, [ Card.new('Mountain', 5) ] }
      it { hand.land_score.should == 5 }
    end
    
    context "with only forest" do
      let(:hand) { Hand.new role, [ Card.new('Forest', 5) ] }
      it { hand.land_score.should == 2 }
    end
    
    context "with only plains" do
      let(:hand) { Hand.new role, [ Card.new('Plains', 5) ] }
      it { hand.land_score.should == 0 }
    end
  end


  context "with role trapper" do
    let(:role){:trapper}
    context "with only mountains" do
      let(:hand) { Hand.new role, [ Card.new('Mountain', 5) ] }
      it { hand.land_score.should == 2 }
    end
    
    context "with only forest" do
      let(:hand) { Hand.new role, [ Card.new('Forest', 5) ] }
      it { hand.land_score.should == 5 }
    end
    
    context "with only plains" do
      let(:hand) { Hand.new role, [ Card.new('Plains', 5) ] }
      it { hand.land_score.should == 0 }
    end

    
  end

  context "with role homesteader" do
    let(:role){:homesteader}
  end
end

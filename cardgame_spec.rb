module MountainRB
  class CardGameHand
    attr_accessor :cards

    def initialize cards
      @cards = cards
    end
  end
end
describe MountainRB::CardGameHand do
  it "takes a list of cards" do
    MountainRB::CardGameHand.new []
  end
end

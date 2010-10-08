Card = Struct.new :type, :value
def cards types,values
  types.map do |type|
    values.map do |value|
      Card.new type, value
    end
  end.flatten
end
LAND_CARDS = cards %w[Mountain Forest Plains], [1,2,3,5,9]

TOOL_CARDS = cards %w[Lasso Pickaxe Plow Traps], [1,2,3,4,8]

RESOURCE_CARDS = cards ['Cattle', 'Ore Vein', 'Seeds', 'Wild Game'], [1, 3, 5, 7]

#BEAST_CARDS = 

DECK = LAND_CARDS + TOOL_CARDS + RESOURCE_CARDS

module Enumerable
  def sum
    unless block_given?
      inject(0){|sum, i| sum + i }
    else
      inject(0){|sum, i| sum + yield(i) }
    end
  end
end

def highest type, cards
  find(type, cards).sort_by {|c| c.value }.first
end

def find type, cards
  cards.select {|c| c.type == type}
end

def score_hand role, cards
  tool_score = land_score = beast_score = resource_score = 0
  full_lands=half_lands=[]
  case role
  when :cowboy
    tool = highest 'Lasso', cards
    resources = find 'Cattle', cards
    full_lands = find 'Plains', cards
    half_lands = find 'Mountain', cards
    beasts = find 'Horse', cards
    
    beast_score = if !full_lands.empty? && half_lands.empty?
                    beasts.sum{|b| b.value}
                  else
                    beasts.sum{|b| b.value / 2 }
                  end
    resource_score = if beasts.empty?
                       0 
                     else
                       resources.sum {|r| r.value }
                     end
  when :prospector
    tool = highest 'Pickaxe', cards
    resources = find 'Ore Vein', cards
    full_lands = find 'Mountain', cards
    half_lands = find 'Forest', cards
    resource_score = resources.sum { |r| r.value }
    beasts = find 'Burro', cards
    beast_score = beasts.sum{|b| b.value * (full_lands.empty? ? 1 : 2)}
  when :homesteader
    tool = highest 'Plow', cards
  when :trapper
    tool = highest 'Traps', cards
  end

  tool_score = tool.value
  land_score = full_lands.sum{|r| r.value} +
               half_lands.sum{|r| r.value/2}  
    
  puts "resource #{resource_score}",
  "land #{land_score}",
  "tool #{tool_score}",
  "beast #{beast_score}"
  resource_score + land_score + tool_score + beast_score

end


ex_score = score_hand :cowboy, [
                      Card.new('Cattle', 3),
                      Card.new('Mountain', 5),
                      Card.new('Lasso', 1),
                      Card.new('Horse', 2)
                     ]
puts ex_score
ex_score2 = score_hand :prospector, [
                      Card.new('Ore Vein', 1),
                      Card.new('Ore Vein', 5),
                      Card.new('Mountain', 3),
                      Card.new('Pickaxe', 4),
                      Card.new('Burro', 2)
                     ]
puts ex_score2

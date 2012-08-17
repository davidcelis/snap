require 'cinch'

module Cinch
  module Plugins
    class Dice
      include Cinch::Plugin
    
      match /roll (?:(\d+))?d(\d+)(?:([+-])(\d+))?/
    
      def execute(m, rolls, sides, operator, offset)
        score = 0
    
        rolls.to_i.times do
          score += rand(sides.to_i)
        end
    
        score.send(operator, offset.to_i) if operator && offset
    
        inflection = sides > 1 ? 'dice' : 'die'
        m.channel.action "casts the #{inflection} and rolls a #{score}", true
      end
    end
  end
end

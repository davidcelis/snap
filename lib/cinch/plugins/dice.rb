require 'cinch'

module Cinch
  module Plugins
    class Dice
      include Cinch::Plugin
    
      USAGE = "Roll some dice. Example: !roll 4d6+3"

      match /roll (?:(\d+))?d(\d+)(?:([+-])(\d+))?/
    
      # Roll one or more dice, RPG style.
      #
      # <davidcelis> !roll 2d6+4
      # * snap casts the dice and rolls a 13
      def execute(m, rolls, sides, operator, offset)
        rolls, sides, offset = rolls.to_i, sides.to_i, offset.to_i
        score = 0
    
        rolls.times do
          score += rand(sides)
        end
    
        score.send(operator, offset) if operator && offset
    
        inflection = sides > 1 ? 'dice' : 'die'
        m.channel.action "casts the #{inflection} and rolls a #{score}"
      end
    end
  end
end

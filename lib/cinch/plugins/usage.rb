require 'cinch'

module Cinch
  module Plugins
    class Usage
      include Cinch::Plugin
      match /usage (\S+)/
      match /help (\S+)$/
    
      def execute(m, command)
        case command
        when 'choose'

        when 'dice'

        when 'disapprove' || 'lod'

        when 'google'

        when 'join'

        when 'lmgtfy'

        when 's'

        when 'seen'
          
        else
          m.reply "I respond to various requests: https://github.com/davidcelis/irc-bot/tree/master/lib/plugins"
        end
      end
    end
  end
end

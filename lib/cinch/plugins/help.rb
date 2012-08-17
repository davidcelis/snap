require 'cinch'

module Cinch
  module Plugins
    class Help
      include Cinch::Plugin

      USAGE = "This is just way too meta."

      match /help(?: (\S+))?/
    
      def execute(m, command)
        usage = case command
                when 'choose'              then Cinch::Plugins::Choose::USAGE
                when 'dice'                then Cinch::Plugins::Dice::USAGE
                when 'disapprove' || 'lod' then Cinch::Plugins::Disapprove::USAGE
                when 'google'              then Cinch::Plugins::Google::USAGE
                when 'help'                then Cinch::Plugins::Help::USAGE
                when 'lmgtfy'              then Cinch::Plugins::LMGTFY::USAGE
                when 's'                   then Cinch::Plugins::S::USAGE
                when 'seen'                then Cinch::Plugins::Seen::USAGE
                else 
                  "I respond to the following commands (preceded by a !): choose, dice, disapprove, google, help, karma, lod, lmgtfy, s, seen. For more info, pass a command to !help"
                end
        m.reply(usage)
      end
    end
  end
end

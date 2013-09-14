require 'cinch'

module Cinch
  module Plugins
    class Help
      include Cinch::Plugin

      USAGE = "This is just way too meta."

      match /help(?: (\S+))?/

      # A basic usage command. Lists commands or, when passed a command, provides
      # usage tips for that command.
      #
      # <davidcelis> !help s
      # <snap> String replacement. Supports g (global) and i (case insensitive) flags. Example: !s/teh/the/i
      def execute(m, command)
        usage = case command
                when 'choose'              then Cinch::Plugins::Choose::USAGE
                when 'roll'                then Cinch::Plugins::Dice::USAGE
                when 'disapprove' || 'lod' then Cinch::Plugins::Disapprove::USAGE
                when 'google'              then Cinch::Plugins::Google::USAGE
                when 'help'                then Cinch::Plugins::Help::USAGE
                when 'info'                then Cinch::Plugins::Info::USAGE
                when 'karma'               then Cinch::Plugins::Karma::USAGE
                when 'lmgtfy'              then Cinch::Plugins::LMGTFY::USAGE
                when 's'                   then Cinch::Plugins::S::USAGE
                when 'seen'                then Cinch::Plugins::Seen::USAGE
                when 'yelp'                then Cinch::Plugins::Yelp::USAGE
                else
                  "I respond to the following commands (preceded by a !): choose, roll, disapprove, google, help, karma, lod, lmgtfy, s, seen, yelp. For more info, pass a command to !help"
                end
        m.reply(usage)
      end
    end
  end
end

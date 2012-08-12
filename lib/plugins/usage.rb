require 'cinch'

module Stark
  module Plugins
    class LMGTFY
      include Cinch::Plugin
      match /usage$/
    
      def execute(m)
        m.reply "I respond to various requests: https://github.com/davidcelis/irc-bot/tree/master/lib/plugins"
      end
    end
  end
end

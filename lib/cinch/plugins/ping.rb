require 'cinch'

module Cinch
  module Plugins
    class Ping
      include Cinch::Plugin

      match /ping/
    
      # An easy check to see if the bot is responding to basic commands.
      #
      # <davidcelis> !ping
      # <snap> davidcelis: Pong!
      def execute(m)
        m.reply "Pong!", true
      end
    end
  end
end

require 'cinch'

module Cinch
  module Plugins
    class Say
      include Cinch::Plugin

      match /say (\S+) (.+)/
    
      def execute(m, channel, message)
        Channel(channel).msg(message) if @bot.admin?(m.user)
      end
    end
  end
end

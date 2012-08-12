require 'cinch'

module Stark
  module Plugins
    class JoinPart
      include Cinch::Plugin
    
      match /join (.+)/, :method => :join
      match /part(?: (.+))?/, :method => :part
    
      def join(m, channel)
        return unless @bot.admin?(m.user)
        Channel(channel).join
      end
    
      def part(m, channel)
        return unless @bot.admin?(m.user)
        channel ||= m.channel
        Channel(channel).part if channel
      end
    end
  end
end

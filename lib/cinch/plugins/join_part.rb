require 'cinch'

module Cinch
  module Plugins
    class JoinPart
      include Cinch::Plugin
    
      match /join (.+)/, :method => :join
      match /part(?: (.+))?/, :method => :part
    
      # Tell the bot to join the channel. Responds only to admins.
      #
      # <davidcelis> !join #cinch-bots
      # => <snap> will join #cinch-bots on the current server.
      def join(m, channel)
        return unless @bot.admin?(m.user)
        Channel(channel).join
      end
    
      # Tell the bot to part the current channel or a passed channel. Responds
      # only to admins.
      #
      # <davidcelis> !part #cinch-bots
      # => <snap> will part #cinch-bots on the current server.
      def part(m, channel)
        return unless @bot.admin?(m.user)
        channel ||= m.channel
        Channel(channel).part if channel
      end
    end
  end
end

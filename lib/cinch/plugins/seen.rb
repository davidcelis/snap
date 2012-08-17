require 'cinch'

module Cinch
  module Plugins
    class Seen
      class SeenStruct < Struct.new(:who, :where, :what, :time)
        def to_s
          "[#{time.asctime}] #{who} was last seen in #{where} saying #{what}"
        end
      end
    
      include Cinch::Plugin

      USAGE = "The last time I saw somebody in this channel. Example: !seen davidcelis"

      listen_to :channel
      match /seen (.+)/
    
      def initialize(*args)
        super
        @users = {}
      end
    
      def listen(m)
        @users[m.user.nick] = SeenStruct.new(m.user, m.channel, m.message, Time.now)
      end
    
      def execute(m, nick)
        if nick == @bot.nick
          m.reply "I haven't been able to see myself since I ascended to a higher plane and became a space robot."
        elsif nick == m.user.nick
          m.reply "I hope you can see yourself."
        elsif @users.key?(nick)
          m.reply @users[nick].to_s
        else
          m.reply "I have never seen \"#{nick}\" before!"
        end
      end
    end
  end
end

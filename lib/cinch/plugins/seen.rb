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
          m.reply "This morning, as I gazed into my mirror."
        elsif nick == m.user.nick
          m.reply "I hope you can see yourself."
        elsif @users.key?(nick)
          m.reply @users[nick].to_s
        else
          m.reply "I am unfamiliar with this \"#{nick}\"."
        end
      end
    end
  end
end

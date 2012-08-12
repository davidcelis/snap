require 'cinch'

module Stark
  module Plugins
    class MessageHistory
      include Cinch::Plugin

      listen_to :channel

      def listen(m)
        return if m.message.to_s =~ /^![a-zA-Z]/ # Don't sed a call to any commands
        return if m.user == @bot

        json = { :nick => m.user.nick, :message => m.message }.to_json

        $redis.lpush "#{m.channel}:#{m.user.nick}:messages", json
        $redis.lpush "#{m.channel}:messages", json

        if $redis.llen("#{m.channel}:#{m.user.nick}:messages").to_i > 100
          $redis.rpop "#{m.channel}:#{m.user.nick}:messages"
        end

        if $redis.llen("#{m.channel}:messages").to_i > 100
          $redis.rpop "#{m.channel}:messages"
        end 
      end
    end
  end
end

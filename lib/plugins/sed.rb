require 'cinch'
require 'json'

module Stark
  module Plugins
    class Sed
      include Cinch::Plugin
    
      match /^!s\/(.+)\/(.*)\/([ig]+)?/
    
      def execute(m, original, replacement, mode)
        case mode
        when 'i'
          history = $redis.lrange("#{m.channel}:#{m.user.nick}:messages", 0, 100).map { |msg| JSON.parse msg }
          found = history.select { |msg| msg['message'] =~ /#{original}/i }
        when 'g'
          history = $redis.lrange("#{m.channel}:messages", 0, 100).map { |msg| JSON.parse msg }
          found = history.select { |msg| msg['message'] =~ /#{original}/ }
        when 'ig', 'gi'
          history = $redis.lrange("#{m.channel}:messages", 0, 100).map { |msg| JSON.parse msg }
          found = history.select { |msg| msg['message'] =~ /#{original}/i }
        else
          history = $redis.lrange("#{m.channel}:#{m.user.nick}:messages", 0, 100).map { |msg| JSON.parse msg }
          found = history.select { |msg| msg['message'] =~ /#{original}/ }
        end

        message = found['message'].gsub(original, replacement)
        nick = found['nick']
    
        message.reply "#{nick} actually meant: #{message}"
      end
    end
  end
end

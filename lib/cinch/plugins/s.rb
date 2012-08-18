require 'cinch'
require 'json'

module Cinch
  module Plugins
    class S
      include Cinch::Plugin

      USAGE = "String replacement. Supports g (global) and i (case insensitive) flags. Example: !s/teh/the/i"
    
      match /s\/(.+)\/(.*)\/([ig]+)?/
    
      def execute(m, original, replacement, mode)
        mode ||= ''
        regex = Regexp.new(original, mode.include?('i'))

        list = if mode.include?('g')
                 "#{m.channel}:messages"
               else
                 "#{m.channel}:#{m.user.nick}:messages"
               end

        history = @bot.redis.lrange(list, 0, 100).map { |msg| JSON.parse msg }
        found = history.select { |msg| msg['message'] =~ regex }.first

        message = found['message'].gsub(regex, replacement)
        nick = found['nick']
    
        m.reply "#{nick} actually meant: #{message}"
      end
    end
  end
end

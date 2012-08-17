require 'cinch'
require 'json'

module Cinch
  module Plugins
    class S
      include Cinch::Plugin
    
      match /s\/(.+)\/(.*)\/([ig]+)?/
    
      def execute(m, original, replacement, mode)
        mode ||= ''
        regex = Regexp.new(original, mode.include?('i'))

        list = if mode.include?('g')
                 "#{m.channel}:messages"
               else
                 "#{m.channel}:#{m.user.nick}:messages"
               end

        history = $redis.lrange(list, 0, 100).map { |msg| JSON.parse msg }
        found = history.select { |msg| msg['message'] =~ regex }.first

        message = found['message'].gsub(regex, replacement)
        nick = found['nick']
    
        m.reply "#{nick} actually meant: #{message}"
      end
    end
  end
end

require 'cinch'
require 'json'

module Cinch
  module Plugins
    class S
      include Cinch::Plugin

      USAGE = "String replacement. Supports g (global) and i (case insensitive) flags. Example: !s/teh/the/i"

      match /s\/(.+)\/(.*)\/([ig]+)?/

      # Replace a part of one of your previous messages. Specifying the 'i' flag
      # at the end of your regular expression group will execute a case
      # insensitive search. Specifying the 'g' flag will search through the global
      # message list rather than the user's own list. Because the searched string
      # is parsed as a Regexp object, Ruby regex syntax is fully supported (this
      # includes referring to captured groups in the replacement section). The
      # bot's messages are not tracked, nor are calls to commands.
      #
      # <davidcelis> lets get some chinese food
      # <naysayer> !s/chinese/greek/g
      # <snap> davidcelis actually meant: lets get some greek food
      # <davidcelis> no i fucking didnt, lets get some motherfucking chinese
      # <naysayer> !s/(?:mother)fucking//g
      # <snap> davidcelis actually meant: no i didnt, lets get some chinese
      # <davidcelis> whatever dude, i'm hugry, lets just go EAT SOMETHING
      # <naysayer> !s/some(thing)/all of the \1s/gi
      # <snap> davidcelis actually meant: whatever dude, i'm hungry lets just go
      # EAT all of the things
      # <davidcelis> deleting that command now.
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

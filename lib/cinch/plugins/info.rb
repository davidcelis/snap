require 'cinch'

module Cinch
  module Plugins
    class Info
      include Cinch::Plugin

      USAGE = "Find out who someone is or set your own information. Example: !info davidcelis [INFO]"

      match /info ([^\s]+)(?:\s+(.+))?/

      # Get info on someone or set your own info.
      #
      # <clueless> !info davidcelis
      # <snap> davidcelis is my father...
      # <davidcelis> !info davidcelis is not a father!
      # <snap> Let me just jot this down... Okay, davidcelis, you're all set!
      def execute(m, user, info)
        if info
          if m.user.nick == user || @bot.admin?(m.user)
            @bot.redis.hset('users:info', user, info)
            m.reply "Let me just jot this down... Okay, #{user}, you're all set!"
          else
            m.reply "I can't let you do that, #{m.user.nick}."
          end
        else
          info = @bot.redis.hget('users:info', user)
          message = info ? "#{user} #{info}" : "#{user} hasn't told me about themselves yet!"
          m.reply message
        end
      end
    end
  end
end

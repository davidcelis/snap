# encoding: utf-8
require 'cinch'

module Cinch
  module Plugins
    class Karma
      include Cinch::Plugin

      UPVOTE_MESSAGES = ['leveled up!', 'is on the rise!', '+1!', 'gained a level!']
      DOWNVOTE_MESSAGES = ['lost a level.', 'took a hit! Ouch.', 'took a hit.', 'lost a life.']

      USAGE = "Get the karma score for someone or something. Example: !karma davidcelis"

      match /karma (\S+)/, :method => :karma_check
      match /(\S+)\+\+/, :use_prefix => false, :method => :upvote
      match /(\S+)\-\-/, :use_prefix => false, :method => :downvote

      # Checks the current karma score of a specified person or thing.
      #
      # <davidcelis> !karma davidcelis
      # <snap> Karma for davidcelis: 12
      def karma_check(m, nick)
        karma = $redis.get("#{m.channel}:#{nick.downcase}:karma")
        m.reply "Karma for #{nick}: #{karma}"
      end

      # Adds one karma to a specified person or thing. Attempts to disapprove if
      # someone tries to upvote themselves.
      #
      # <davidcelis> coffee++
      # <snap> coffee is on the rise! Karma: 328
      def upvote(m, nick)
        user = User(nick)
        m.reply "Nice try, #{nick}. ಠ_ಠ" and return if user == m.user

        karma = $redis.incr("#{m.channel}:#{nick.downcase}:karma")
        m.reply "#{nick} #{UPVOTE_MESSAGES.sample} Karma: #{karma}."
      end

      # Subtracts one karma to a specified person or thing. Attempts to
      # disapprove if someone tries to downvote themselves.
      #
      # <davidcelis> twilight++
      # <snap> twilight took a hit! Ouch. Karma: -184758438
      def downvote(m, nick)
        user = User(nick)
        m.reply "Nice try, #{nick}. ಠ_ಠ" and return if user == m.user

        karma = $redis.decr("#{m.channel}:#{nick.downcase}:karma")
        m.reply "#{nick} #{DOWNVOTE_MESSAGES.sample} Karma: #{karma}."
      end
    end
  end
end

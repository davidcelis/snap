# encoding: utf-8
require 'cinch'

module Stark
  module Plugins
    class Karma
      include Cinch::Plugin

      UPVOTE_MESSAGES = ['leveled up!', 'is on the rise!', '+1!', 'gained a level!']
      DOWNVOTE_MESSAGES = ['lost a level.', 'took a hit! Ouch.', 'took a hit.', 'lost a life.']

      match /(\S+)\+\+/, :use_prefix => false, :method => :upvote
      match /(\S+)\-\-/, :use_prefix => false, :method => :downvote

      def upvote(m, nick)
        user = User(nick)
        m.reply "Nice try, #{nick}. ಠ_ಠ" and return if user == m.user

        karma = $redis.incr("#{m.channel}:#{nick.downcase}:karma")
        m.reply "#{nick} #{UPVOTE_MESSAGES.sample} Karma: #{karma}."
      end

      def downvote(m, nick)
        user = User(nick)
        m.reply "Nice try, #{nick}. ಠ_ಠ" and return if user == m.user

        karma = $redis.decr("#{m.channel}:#{nick.downcase}:karma")
        m.reply "#{nick} #{DOWNVOTE_MESSAGES.sample} Karma: #{karma}."
      end
    end
  end
end

require 'cinch'
require 'yaml'

module Snap
  class Bot < Cinch::Bot
    def initialize(options = {})
      super() do
        configure do |config|
          config.server = options[:server]
          config.channels = options[:channels]
          config.nick = options[:nick]
          config.user = options[:username]

          config.plugins.plugins = [
            Cinch::Plugins::Identify,
            Cinch::Plugins::Choose,
            Cinch::Plugins::Dice,
            Cinch::Plugins::Disapprove,
            Cinch::Plugins::Google,
            Cinch::Plugins::Help,
            Cinch::Plugins::JoinPart,
            Cinch::Plugins::Karma,
            Cinch::Plugins::LinkScraper,
            Cinch::Plugins::LMGTFY,
            Cinch::Plugins::MessageHistory,
            Cinch::Plugins::Ping,
            Cinch::Plugins::S,
            Cinch::Plugins::Say,
            Cinch::Plugins::Seen
          ]

          config.plugins.options[Cinch::Plugins::Identify] = {
            :username => options[:username],
            :password => options[:password],
            :type     => :nickserv
          }

          config.plugins.options[Cinch::Plugins::MessageHistory] = {
            :user_messages => 10,
            :channel_messages => 25
          }
        end

        def redis=(redis) @redis = redis end
        def redis() @redis end

        def admins=(admins) @admins = admins end
        def admins() @admins end

        def admin?(user)
          user.refresh
          admins.include?(user.authname)
        end
      end
    end
  end
end

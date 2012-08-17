require 'cinch'
require 'yaml'

module Snap
  class Bot < Cinch::Bot
    def initialize(options = {})
      super() do
        puts options.inspect
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
            Cinch::Plugins::JoinPart,
            Cinch::Plugins::Karma,
            Cinch::Plugins::LinkScraper,
            Cinch::Plugins::LMGTFY,
            Cinch::Plugins::MessageHistory,
            Cinch::Plugins::S,
            Cinch::Plugins::Seen,
            Cinch::Plugins::Usage
          ]

          config.plugins.options[Cinch::Plugins::Identify] = {
            :username => options[:username],
            :password => options[:password],
            :type     => :nickserv
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

        on :message, /^!ping$/ do |m|
          m.reply "#{m.user.nick}: pong!"
        end

        on :private, /^!say "(.+?)" in (#.+)$/ do |m, msg, channel|
          Channel(channel).msg(msg) if admin?(m.user)
        end
      end
    end
  end
end

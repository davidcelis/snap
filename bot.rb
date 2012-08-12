require 'rubygems'
require 'yaml'
require 'cinch'
require 'cinch/plugins/identify'
require 'redis'

Dir[File.join(File.dirname(__FILE__), 'lib', 'plugins', '*')].each { |f| require f }

bot = Cinch::Bot.new do
  configure do |config|
    config.server = 'irc.freenode.org'
    config.channels = ['#reddit-portland']
    config.nick = 'EddardStark'
    config.user = 'Eddard'

    ident = YAML::load_file(File.join(File.dirname(__FILE__), 'config', 'auth.yml'))

    config.plugins.plugins = [
      Cinch::Plugins::Identify,
      Stark::Plugins::Choose,
      Stark::Plugins::Dice,
      Stark::Plugins::Disapprove,
      Stark::Plugins::JoinPart,
      Stark::Plugins::MessageHistory,
      Stark::Plugins::Sed,
      Stark::Plugins::Seen
    ]

    config.plugins.options[Cinch::Plugins::Identify] = {
      :username => ident['auth']['username'],
      :password => ident['auth']['password'],
      :type     => ident['auth']['type'].to_sym
    }
  end
end

$redis = Redis.new

bot.start

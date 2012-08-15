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
      Stark::Plugins::Google,
      Stark::Plugins::JoinPart,
      Stark::Plugins::Karma,
      Stark::Plugins::LinkScraper,
      Stark::Plugins::LMGTFY,
      Stark::Plugins::MessageHistory,
      Stark::Plugins::S,
      Stark::Plugins::Seen,
      Stark::Plugins::Usage
    ]

    config.plugins.options[Cinch::Plugins::Identify] = {
      :username => ident['auth']['nickserv']['username'],
      :password => ident['auth']['nickserv']['password'],
      :type     => :nickserv
    }
  end

  def admins
    ['davidcelis', 'loveinacoffeecup']
  end

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

$redis = Redis.new

bot.start

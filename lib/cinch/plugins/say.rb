require 'cinch'

module Cinch
  module Plugins
    class Say
      include Cinch::Plugin

      match /say "(.+)" in (\S+)/
    
      def execute(m, message, channel)
        Channel(channel).msg(msg) if admin?(m.user)
      end
    end
  end
end

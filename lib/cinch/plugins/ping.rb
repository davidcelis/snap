require 'cinch'

module Cinch
  module Plugins
    class Ping
      include Cinch::Plugin

      match /ping/
    
      def execute(m, list)
        m.reply "Pong!", true
      end
    end
  end
end

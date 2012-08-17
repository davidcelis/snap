require 'cinch'

module Cinch
  module Plugins
    class LMGTFY
      include Cinch::Plugin
      match /lmgtfy (.+)/
    
      def execute(m, query)
        m.reply "http://lmgtfy.com/?q=#{CGI.escape(query)}"
      end
    end
  end
end

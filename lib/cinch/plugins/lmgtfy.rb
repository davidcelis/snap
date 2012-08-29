require 'cinch'

module Cinch
  module Plugins
    class LMGTFY
      include Cinch::Plugin

      USAGE = "Oh, let me google that for you. Example: !lmgtfy your stupid question"

      match /lmgtfy (.+)/

      # Drown a user in your hatred for their inability to google their own
      # simple questions.
      #
      # <clueless> my car's blinker is blinking super fast, what's that mean
      # <davidcelis> !lmgtfy interior blinker fast
      # <snap> http://lmgtfy.com/?q=interior+blinker+fast
      def execute(m, query)
        m.reply "http://lmgtfy.com/?q=#{CGI.escape(query)}"
      end
    end
  end
end

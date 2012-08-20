# encoding: utf-8
require 'cinch'

module Cinch
  module Plugins
    class Disapprove
      include Cinch::Plugin

      USAGE = "Share the hate. Example: !disapprove davidcelis <OR> !lod davidcelis"

      match /disapprove (.+)/
      match /lod (.+)/

      # Disapprove of another channel member.
      #
      # <davidcelis> !disapprove clueless
      # <snap> clueless: ಠ_ಠ
      def execute(m, nick)
        m.reply "#{nick}: ಠ_ಠ"
      end
    end
  end
end

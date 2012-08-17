# encoding: utf-8
require 'cinch'

module Cinch
  module Plugins
    class Disapprove
      include Cinch::Plugin

      match /disapprove (.+)/
      match /lod (.+)/

      def execute(m, nick)
        m.reply "#{nick}: ಠ_ಠ"
      end
    end
  end
end

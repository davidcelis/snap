# encoding: utf-8
require 'cinch'

module Stark
  module Plugins
    class Disapprove
      include Cinch::Plugin

      match /disapprove (.+)/

      def execute(m, nick)
        m.reply "#{nick}: You have shamed your house. ಠ_ಠ"
      end
    end
  end
end

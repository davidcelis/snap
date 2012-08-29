require 'cinch'

module Cinch
  module Plugins
    class Choose
      include Cinch::Plugin

      USAGE = "Allow me to make a decision for you. Example: !choose several, comma separated, things"

      match /choose (.+)/

      # Takes a simple list of comma separated items and chooses one at random.
      #
      # <davidcelis> !choose tea, coffee, disgusting energy drink
      # * snap reaches into a bag and pulls out coffee.
      def execute(m, list)
        items = list.split ','

        m.channel.action "reaches into a bag and pulls out #{items.sample.strip}."
      end
    end
  end
end

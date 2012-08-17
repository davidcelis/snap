require 'cinch'

module Cinch
  module Plugins
    class Choose
      include Cinch::Plugin
    
      USAGE = "Allow me to make a decision for you. Example: !choose several, comma separated, things"

      match /choose (.+)/
    
      def execute(m, list)
        items = list.split ','
        
        m.channel.action "reaches into a bag and pulls out #{items.sample.strip}."
      end
    end
  end
end

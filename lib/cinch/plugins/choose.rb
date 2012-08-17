require 'cinch'

module Cinch
  module Plugins
    class Choose
      include Cinch::Plugin
    
      match /choose (.+)/
    
      def execute(m, list)
        items = list.split ','
        
        m.channel.action "reaches into a bag and pulls out #{items.sample.strip}."
      end
    end
  end
end

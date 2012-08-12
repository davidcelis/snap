require 'cinch'

module Stark
  module Plugins
    class Choose
      include Cinch::Plugin
    
      match /choose (.+)/
    
      def execute(m, list)
        items = list.split ','
        
        m.reply "The answer is #{items.sample.strip}. It is known.", true
      end
    end
  end
end

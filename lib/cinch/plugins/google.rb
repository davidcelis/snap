require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

module Cinch
  module Plugins
    class Google
      include Cinch::Plugin

      USAGE = "Do you feel lucky, punk? Example: !google how to make friends"

      match /google (.+)/
    
      def search(query)
        begin
          url = "http://www.google.com/search?q=#{CGI.escape(query)}"
          res = Nokogiri::HTML(open(url)).at("h3.r")
      
          title = res.text
          link = res.at('a')[:href]
          desc = res.at("./following::div").children.first.text
          CGI.unescape_html "#{title} - #{desc} (#{link})"
        rescue
          "No results found"
        end
      end
    
      # Perform an "I'm feeling lucky" Google search on a passed query.
      #
      # <davidcelis> !google ruby yard guide
      # <snap> YARD - Guide: Writing a Handler for Custom Ruby Syntax (DSL) -
      # yardoc.org/guides/extending-yard/writing-handlers.html - Cached -
      # Similar (/url?q=http://yardoc.org/guides/extending-yard/writing-handlers
      # .html&sa=U&ei=gYMyUPz3OczbiwKmx4CoBw&ved=0CBQQFjAA&usg=AFQjCNEcUeaCxxTO5Bs64THc-SI3E4AyyA)
      def execute(m, query)
        m.reply(search(query))
      end
    end
  end
end

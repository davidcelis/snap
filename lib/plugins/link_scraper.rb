require 'mechanize'
require 'json'

module Stark
  module Plugins
    class LinkScraper
      include Cinch::Plugin

      def initialize(*args)
        super

        @agent = Mechanize.new
        @agent.user_agent_alias = 'Mac Safari'
        @agent.max_history = 0
      end

      listen_to :channel

      def listen(m)
        URI.extract(m.message) do |link|
          begin
            uri = URI.parse(link)
            page = @agent.get(link)
          rescue Mechanize::ResponseCodeError
            m.reply "Your link is broken, #{m.user.nick}."
            next
          end

          title = page.title

          case uri.host
          when 'www.youtube.com'
            page = @agent.get(link + '&nofeather=True')

            title = page.title.strip.gsub("- YouTube", '').strip
            hits = page.search("//span[@class='watch-view-count']/strong").text.gsub(',', '')
            ratings = page.search("//span[@class='video-extras-likes-dislikes']").text.strip.gsub(/(\d),(\d)/, '\1\2')

            m.reply "#{title} (#{hits} views, #{ratings})"
          when 'gist.github.com'
            owner = page.search("//div[@class='name']/a").inner_html
            date = page.search("//span[@class='date']/time").first.text

            m.reply "#{title} posted by #{owner} on #{date}."
          when 'twitter.com'
            if link =~ /\/([^\/]+)\/status\/(\d+)$/
              user = $1
              json      = @agent.get("https://api.twitter.com/1/statuses/show/#{$2}.json?trim_user=1").body
              tweet     = JSON.parse(json)
              unescaped = CGI.unescapeHTML(tweet["text"])

              m.reply "@#{user}: #{unescaped}"
            else
              m.reply "Title: #{title} (at #{uri.host})"
            end
          else
            m.reply "Title: #{title} (at #{uri.host})"
          end
        end
      end
    end
  end
end

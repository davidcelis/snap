require 'mechanize'
require 'fastimage'
require 'json'

module Cinch
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

      # Listens to all incoming messages in the channel for links. Grabs the
      # first parsable link out of a message that it can and loads it for
      # certain attributes. Basic pages will retrieve a title and the host
      # domain. YouTube links will be parsed for likes/dislikes/views. Tweets
      # will be parsed and returned to the channel. Images will have their
      # dimensions and file name fetched. Gists will be parsed for their owner
      # and post date.
      #
      # <davidcelis> I didn't know they did this: http://imgur.com/jYjq8
      # <snap> Voodoo Doughnuts sold me a bucket of "extra" doughnuts for $5! - Imgur (at imgur.com)
      def listen(m)
        return if m.user == @bot || m.user.nil?
        
        URI.extract(m.message) do |link|
          begin
            uri = URI.parse(link)
            page = @agent.get(link)
          rescue URI::InvalidURIError, Mechanize::ResponseCodeError
            next
          end

          if page.is_a?(Mechanize::Image)
            size = FastImage.size(page.body_io)
            m.reply "#{page.filename} - #{size[0]}x#{size[1]}" and return
          end

          title = page.title.strip

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
            if link =~ /\/([^\/]+)\/status(?:es)\/(\d+)$/
              user = $1
              json      = @agent.get("https://api.twitter.com/1/statuses/show/#{$2}.json?trim_user=1").body
              tweet     = JSON.parse(json)

              unescaped = CGI.unescapeHTML(tweet['text'])
              time      = Time.parse(tweet['created_at']).strftime('%T on %D')

              m.reply "@#{user}: #{unescaped} (at #{time})"
            else
              m.reply "#{title} (at #{uri.host})"
            end
          else
            m.reply "#{title} (at #{uri.host})"
          end
        end
      end
    end
  end
end

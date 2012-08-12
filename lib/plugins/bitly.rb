require 'httparty'
require 'mechanize'
require 'uri'
require 'cgi'

module Stark
  module Plugins
    class Bitly
      include Cinch::Plugin

      def initialize(*args)
        super

        auth = YAML::load_file(File.join(File.dirname(__FILE__), 'config', 'auth.yml'))
        @api_key = auth['bitly']['api_key']
        @api_user = auth['bitly']['user']
      end

      listen_to :channel

      def listen(m)
        begin
          link = URI.extract(m.message).first
          return unless link

          page = Mechanize.new.get(link)
          title = page.title
          uri = CGI.escape(page.uri.to_s)

          response = HTTParty.get("https://api-ssl.bitly.com/v3/shorten?login=#{@api_user}&apiKey=#{@api_key}&longUrl=#{uri}")
          shortened_uri = response['data']['url']

          m.reply "#{title} - #{shortened_uri}"
        rescue SocketError, Mechanize::ResponseCodeError
          return
        end
      end
    end
  end
end

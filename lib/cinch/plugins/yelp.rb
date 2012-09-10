require 'cinch'
require 'yelpster'

module Cinch
  module Plugins
    class Yelp
      include Cinch::Plugin

      USAGE = "Search Yelp for something near a location. Example: !yelp brunch near Hawthorne, Portland, OR"

      def initialize(*args)
        super

        @client = ::Yelp::Client.new
      end

      match /yelp (.+) (?:near|in|at) (.+)$/

      # Search Yelp for something somewhere and return a random business.
      #
      # <davidcelis> !yelp brunch in Portland, OR
      # <snap> davidcelis: You should try Tasty n Sons (4.5 stars, 664 reviews). http://www.yelp.com/biz/tasty-n-sons-portland
      def execute(m, query, location)
        request = ::Yelp::V2::Search::Request::Location.new({
          :term => query,
          :address => location,
          :consumer_key => config['consumer_key'],
          :consumer_secret => config['consumer_secret'],
          :token => config['token'],
          :token_secret => config['token_secret']
        })

        response = @client.search(request)

        m.reply("Oops, Yelp didn't understand that location!", true) and return if response['error']
        m.reply("Sorry, Yelp doesn't have any businesses matching #{query} near #{location}!") and return if response['businesses'].empty?

        business = response['businesses'].sample
        name = business['name']
        rating = business['rating']
        reviews = business['review_count']
        url = business['url']
        address = business['location']['address'].first

        m.reply "You should try #{name} at #{address}! It's rated #{rating} stars with #{reviews} reviews: #{url}", true
      end
    end
  end
end

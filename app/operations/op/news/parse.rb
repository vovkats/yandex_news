module Op
  module News
    class Parse
      URL = 'https://news.yandex.ru/ru/index5.utf8.js'.freeze
      TIMEOUT_SECONDS = 10.freeze
      TYPE = 'yandex'.freeze

      TimeoutError = Class.new(StandardError)
      CorrespondingContentNotFound = Class.new(StandardError)

      def self.execute
        new.execute
      end

      def initialize
        @errors = []
        @news = []
      end

      def execute
        @news = parse(data)

        { errors: @errors, news: @news}
      end

      private

      def parse(data)
        return [] unless data

        news_string = /\[.+\]/.match(data)

        if news_string && news_string[0]
          JSON.parse(news_string[0]).map do |yandex_news|
            {
              ts: yandex_news['ts'],
              time: yandex_news['time'],
              date: yandex_news['date'],
              title: yandex_news['title'],
              description: yandex_news['descr']
            }
          end
        else
          @errors << CorrespondingContentNotFound.new
          []
        end
      end

      def data
        response = RestClient::Request.execute(method: :get, url: URL, timeout: TIMEOUT_SECONDS)
        response.body
      rescue RestClient::Exceptions::Timeout
        @errors << TimeoutError.new
        nil
      end
    end
  end
end
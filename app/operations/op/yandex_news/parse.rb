module Op
  module YandexNews
    class Parse
      URL = 'https://news.yandex.ru/ru/index5.utf8.js'.freeze
      TIMEOUT_SECONDS = 10.freeze
      TYPE = 'yandex'.freeze

      TimeoutError = Class.new(StandardError)
      CorrespondingContentNotFound = Class.new(StandardError)
      CorruptedData = Class.new(StandardError)

      def self.execute
        new.execute
      end

      def initialize
        @errors = []
        @news = []
      end

      def execute
        @news = parse(data)
        check_data_on_errors

        { errors: @errors, news: @news}
      end

      private

      def data
        response = RestClient::Request.execute(method: :get, url: URL, timeout: TIMEOUT_SECONDS)
        response.body
      rescue RestClient::Exceptions::Timeout
        @errors << TimeoutError.new
        nil
      end

      def check_data_on_errors
        @news.each do |news|
          if news[:time].zero? || news[:description].blank? || news[:title].blank?
            @errors << CorruptedData.new
            @news = []
            break
          end
        end
      end

      def parse(data)
        return [] unless data

        news_string = /\[.+\]/.match(data)

        if news_string && news_string[0]
          JSON.parse(news_string[0]).map do |yandex_news|
            {
              time: yandex_news['ts'].to_i,
              title: yandex_news['title'],
              description: yandex_news['descr']
            }
          end
        else
          @errors << CorrespondingContentNotFound.new
          []
        end
      end
    end
  end
end
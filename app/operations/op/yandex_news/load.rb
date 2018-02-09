module Op
  module YandexNews
    class Load
      def self.execute
        new.execute
      end

      def initialize
        @errors = { parsed_errors: [], news_errors: []}
        @parsed_news = []
        @main_yandex_news_attrs = nil
        @main_yandex_news = nil
      end

      def execute
        parse_news

        return result unless has_news?

        extract_main_yandex_news_attrs
        set_main_yandex_news

        return result unless @main_yandex_news

        if main_news?
          broadcast_to_news_channel
        end
      end

      private

      def parse_news
        result = ::Op::YandexNews::Parse.execute
        if result[:errors].present?
          @errors[:parsed_errors].push(*result[:errors])
        else
          @parsed_news = result[:news]
        end
      end

      def has_news?
        @parsed_news.present?
      end

      def extract_main_yandex_news_attrs
        @main_yandex_news_attrs = @parsed_news.first
      end

      def set_main_yandex_news
        @main_yandex_news =
          if news_saved_in_db?
            find_and_set_main_news
          else
            save_main_news
          end
      end

      def news_saved_in_db?
        saved_news.present?
      end

      def saved_news
        ::YaNews.find_by(title: @main_yandex_news_attrs[:title])
      end

      def save_main_news
        ActiveRecord::Base.transaction do
          previous_main_news = ::YaNews.find_by(main: true)
          previous_main_news.update!(main: false) if previous_main_news
          save_news
        end
      rescue ActiveRecord::RecordInvalid
        @errors[:news_errors] << 'can not save/update data'
        nil
      end

      def find_and_set_main_news
        ActiveRecord::Base.transaction do
          previous_main_news = ::YaNews.find_by(main: true)
          previous_main_news.update!(main: false) if previous_main_news
          saved_news.tap do |n|
            n.main = true
            n.save!
          end
        end
      rescue ActiveRecord::RecordInvalid
        @errors[:news_errors] << 'can not save/update data'
      end

      def main_news?
        @main_yandex_news == Op::MainNews::Get.execute
      end

      def broadcast_to_news_channel
        ActionCable.server.broadcast(
          'news_channel',
          time: @main_yandex_news[:time],
          title: @main_yandex_news[:title],
          description: @main_yandex_news[:description]
        )
      end

      def save_news
        @saved_news ||= Op::YandexNews::Save.execute(YaNews.new,
           title: @main_yandex_news_attrs[:title],
           description: @main_yandex_news_attrs[:description],
           time: @main_yandex_news_attrs[:time]
        )
      end

      def result
        {
          errors: @errors,
          parsed_news: @parsed_news,
          main_yandex_news_attrs: @main_yandex_news_attrs,
          main_yandex_news: @main_yandex_news
        }
      end
    end
  end
end


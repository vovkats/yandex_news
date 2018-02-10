module Op
  module AuthorsNews
    class Update
      def self.execute(attributes)
        new(attributes).execute
      end

      attr_reader :attributes

      def initialize(attributes)
        @attributes = attributes
        @news = nil
        @errors = []
      end

      def execute
        unless news.persisted?
          @errors << ::I18n.t('authors_news.errors.can_not_find_actual_authors_news')
          return result
        end

        updated_news ||= Op::AuthorsNews::Save.execute(news, attributes)

        unless updated_news.valid?
          @errors.push(*updated_news.errors.full_messages)
        end

        result
      end

      private

      def news
        @news ||= Op::AuthorsNews::Get.execute
      end

      def result
        { errors: @errors, news: @news }
      end
    end
  end
end


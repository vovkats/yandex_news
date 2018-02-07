module Op
  module AuthorsNews
    class Save
      def self.execute(news, attributes)
        new(news, attributes).execute
      end

      attr_reader :attributes

      def initialize(news, attributes = {})
        @news = news
        @attributes = attributes
      end

      def execute
        @news.tap do |n|
          n.title = attributes[:title]
          n.description = attributes[:description]
          n.time = Time.at(attributes[:time].to_i)
          n.show_until = attributes[:show_until]
          n.save
        end
      end
    end
  end
end


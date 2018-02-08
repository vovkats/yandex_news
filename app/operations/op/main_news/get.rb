module Op
  module MainNews
    class Get

      def self.execute
        author_news = ::News.where('show_until > ?', Time.zone.now).first
        return author_news if author_news

        ::YaNews.find_by(main: true)
      end
    end
  end
end
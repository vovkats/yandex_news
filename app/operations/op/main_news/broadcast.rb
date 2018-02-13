module Op
  module MainNews
    class Broadcast

      def self.execute(news)
        ActionCable.server.broadcast(
          'news_channel',
          time: news[:time].strftime('%F %H:%M'),
          title: news[:title],
          description: news[:description]
        )
      end
    end
  end
end
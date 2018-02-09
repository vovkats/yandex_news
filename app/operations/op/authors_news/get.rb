module Op
  module AuthorsNews
    class Get
      def self.execute
        ::News.where('show_until > ?', Time.zone.now).first || ::News.new
      end
    end
  end
end


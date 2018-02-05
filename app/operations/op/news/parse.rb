module Op
  module News
    class Parse
      attr_reader :source

      def self.execute(source)
        new(source).execute
      end

      def initialize(source)
        @source = source
      end

      def execute
        @row_data = source.parse
      end
    end
  end
end
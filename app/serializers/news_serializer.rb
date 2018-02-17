class NewsSerializer < BaseSerializer
  NEWS_ATTRIBUTES = %i(id title description show_until time)

  def serialize
    {}.tap do |json|
      if data.errors.present?
        json[:errors] = data.errors.full_messages
        json[:status] = ERROR_STATUS
      else
        json[:errors] = []
        json[:status] = SUCCESS_STATUS
      end

      json[:data] = data.as_json(only: NEWS_ATTRIBUTES)
    end
  end
end
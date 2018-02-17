class NewsResultSerializer < BaseSerializer

  def serialize
    {}.tap do |json|
      json[:errors] = data[:errors]
      json[:data] = NewsSerializer.new(data[:news]).serialize[:data]

      json[:status] =
        if data[:errors].present?
          ERROR_STATUS
        else
          SUCCESS_STATUS
        end
    end
  end
end
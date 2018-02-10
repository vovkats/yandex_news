class NewsResultSerializer < BaseSerializer

  private

  def serialize
    {}.tap do |json|
      json[:errors] = data[:errors]
      json[:data] = NewsSerializer.new(data[:news]).as_json

      json[:status] =
        if data[:errors].present?
          ERROR_STATUS
        else
          SUCCESS_STATUS
        end
    end.stringify_keys
  end
end
class BaseSerializer
  attr_reader :data

  SUCCESS_STATUS = 'success'.freeze
  ERROR_STATUS = 'error'.freeze

  def initialize(data)
    @data = data
  end

  def as_json
    serialize
  end

  private

  def serialize
    raise NotImplementedError, 'need to implement method serialize'
  end
end
require 'rails_helper'

describe News, type: :model do
  %i(title description time show_until).each do |attr|
    it { is_expected.to validate_presence_of(attr) }
  end
end

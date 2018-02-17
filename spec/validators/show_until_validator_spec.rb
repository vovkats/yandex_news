require 'rails_helper'


describe ShowUntilValidator do
  subject { FactoryBot.build(:news, show_until: show_until) }

  context 'without show until time' do
    let(:show_until) { nil }
    it 'is valid' do
      expect(subject).to be_invalid
    end
  end

  context 'with invalid show until time' do
    let(:show_until) { Time.zone.now - 10.seconds }

    it 'is invalid' do
      expect(subject).to be_invalid
    end
  end

  context 'with valid show until time' do
    let(:show_until) { Time.zone.now + 10.seconds }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
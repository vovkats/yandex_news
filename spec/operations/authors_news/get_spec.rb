require 'rails_helper'

describe Op::AuthorsNews::Get do
  let(:get) { described_class.execute }

  context 'when actual authors news exists' do
    let!(:news) { FactoryBot.create(:news, show_until: Time.zone.now + 10.seconds )}

    it 'returns saved authors news' do
      expect(get).to eq(news)
    end
  end

  context 'when actual authors news does not exist' do
    it 'returns empty ::News object' do
      expect(get).to be_instance_of(::News)
      expect(get.id).to be_nil
    end
  end
end
require 'rails_helper'

describe Op::MainNews::Get do
  let(:save) { described_class.execute  }

  context 'when actual author and yandex news exist' do
    let!(:ya_news) { create(:ya_news, main: true) }
    let!(:news) { create(:news, show_until: Time.zone.now + 10.seconds) }

    it 'returns authors news' do
      expect(save).to eq(news)
    end
  end

  context 'when only actual yandex news exists' do
    let!(:ya_news) { create(:ya_news, main: true) }
    let!(:news) do
      build(:news).tap do |n|
        n.show_until = Time.zone.now - 10.seconds
        n.save
      end
    end

    it 'returns yandex news' do
      expect(save).to eq(ya_news)
    end
  end

  context 'when author and yandex news does not exist ' do
    it 'returns nil' do
      expect(save).to be_nil
    end
  end
end
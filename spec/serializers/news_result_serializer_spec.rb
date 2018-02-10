require 'rails_helper'

describe NewsResultSerializer do
  let(:as_json) { described_class.new(news_result).as_json }

  context 'when result does not contain errors' do
    let(:news_result) do
      {
        errors: [],
        news: FactoryBot.create(:news)
      }
    end

    it 'sets status field to "success"' do
      expect(as_json['status']).to eq(described_class::SUCCESS_STATUS)
    end

    it 'serialize news' do
      expect(as_json['data']).to eq(NewsSerializer.new(news_result[:news]).as_json)
    end

    it 'contains empty field errors' do
      expect(as_json['errors']).to be_blank
    end
  end

  context 'when result contains errors' do
    let(:news_result) do
      {
        errors: ['some error'],
        news: FactoryBot.create(:news)
      }
    end

    it 'sets status field to "error"' do
      expect(as_json['status']).to eq(described_class::ERROR_STATUS)
    end

    it 'serialize news' do
      expect(as_json['data']).to eq(NewsSerializer.new(news_result[:news]).as_json)
    end

    it 'contains empty field errors' do
      expect(as_json['errors']).to be_present
    end
  end
end
require 'rails_helper'

describe NewsSerializer do
  let(:as_json) { described_class.new(news).as_json }

  context 'when news does not have errors' do
    let(:news) { FactoryBot.create(:news) }

    it 'sets status field to "success"' do
      expect(as_json['status']).to eq(described_class::SUCCESS_STATUS)
    end

    %w(title description time show_until).each do |attr|
      it "serializes data field with attributes '#{attr}'" do
        expect(as_json['data'][attr]).to eq(news[attr])
      end
    end

    it 'sets empty field errors' do
      expect(as_json['errors']).to be_blank
    end
  end

  context 'when news has errors' do
    let(:news) do
      FactoryBot.build(:news, title: '').tap(&:save)
    end

    it 'sets status field to "error"' do
      expect(as_json['status']).to eq(described_class::ERROR_STATUS)
    end

    %w(title description time show_until).each do |attr|
      it "serializes data field with attributes '#{attr}'" do
        expect(as_json['data'][attr]).to eq(news[attr])
      end
    end

    it 'filled "errors" field' do
      expect(as_json['errors']).to be_present
    end
  end
end
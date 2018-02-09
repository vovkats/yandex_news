require 'rails_helper'

describe Op::YandexNews::Parse do
  let(:parse) { described_class.execute }

  context 'when resource is unavailable' do
    before do
      allow(RestClient::Request).to receive(:execute).and_raise(RestClient::Exceptions::Timeout)
    end

    it 'has Op::News::Parse::TimeoutError' do
      expect(parse[:errors]).to contain_exactly(described_class::TimeoutError)
    end

    it 'returns empty news result' do
      expect(parse[:news]).to be_blank
    end
  end

  context 'when resource is available' do

    context 'and answer does not contain information about news' do
      before do
        allow(RestClient::Request).to receive(:execute) do
          double(body: File.read("#{TEST_DATA}/news/incorrect_data.txt"))
        end
      end

      it 'has Op::News::Parse::CorrespondingContentNotFound' do
        expect(parse[:errors]).to contain_exactly(described_class::CorrespondingContentNotFound)
      end

      it 'returns empty news result' do
        expect(parse[:news]).to be_blank
      end
    end

    context 'and answer contains information about news' do
      before do
        allow(RestClient::Request).to receive(:execute) do
          double(body: File.read("#{TEST_DATA}/news/correct_data.txt"))
        end
      end

      it 'does not have errors' do
        expect(parse[:errors]).to be_blank
      end

      it 'returns not empty news result' do
        expect(parse[:news]).to be_present
      end

      it 'forms certain attributes for news' do
        news = parse[:news].first

        aggregate_failures 'news attributes' do
          %i(time title description).each do |key|
            expect(news).to have_key(key)
          end
        end
      end
    end

    context 'and data is corrupted' do
      before do
        allow(RestClient::Request).to receive(:execute) do
          double(body: File.read("#{TEST_DATA}/news/corrupted_data.txt"))
        end
      end

      it 'has Op::News::Parse::CorruptedData' do
        expect(parse[:errors]).to contain_exactly(described_class::CorruptedData)
      end

      it 'returns empty news result' do
        expect(parse[:news]).to be_blank
      end
    end
  end
end
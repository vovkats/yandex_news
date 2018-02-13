require 'rails_helper'

describe Op::AuthorsNews::Update do
  let(:update) { described_class.execute(attributes) }

  let(:invalid_attributes) do
    {
      title: '',
      description: Faker::Lorem.sentence(3),
      time: 1518022111,
      show_until: Time.at(1518025221)
    }
  end

  let(:valid_attributes) do
    {
      title: Faker::Lorem.word,
      description: Faker::Lorem.sentence(3),
      time: 1518021127,
      show_until: Time.at(1518025987)
    }
  end

  context 'when actual authors news does not exist' do
    let!(:news) do
      FactoryBot.create(:news, show_until: Time.zone.now - 10.seconds)
    end

    let(:attributes) { {} }

    it 'returns result with errors filled field' do
      expect(update[:errors]).to eq(
        [::I18n.t('authors_news.errors.can_not_find_actual_authors_news')]
      )
    end
  end

  context 'when actual authors news exists' do
    let!(:news) do
      FactoryBot.create(:news, show_until: Time.zone.now + 10.seconds)
    end

    context 'and attributes are valid' do
      let(:attributes) { valid_attributes }

      it 'updates authors news' do
        update
        news.reload

        aggregate_failures 'news attributes' do
          %i(title description show_until).each do |attr_name|
            expect(news.public_send(attr_name)).to eq(attributes[attr_name])
          end

          expect(news.time).to_not eq(Time.at(attributes[:time]))
        end
      end

      it 'sends data to NewsChannel' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'news_channel',
          title: attributes[:title],
          description: attributes[:description],
          time: Time.at(news.reload.time).strftime('%F %H:%M')
        )

        update
      end

      it 'does not contain errors about invalid attributes' do
        expect(update[:errors]).to be_empty
      end

      it 'contain updates news object in result' do
        expect(update[:news]).to eq(news.reload)
      end
    end

    context 'and attributes are invalid' do
      let(:attributes) { invalid_attributes }

      it 'does not update authors news' do
        update
        news.reload

        aggregate_failures 'news attributes' do
          %i(title description show_until).each do |attr_name|
            expect(news.public_send(attr_name)).to_not eq(attributes[attr_name])
          end

          expect(news.time).to_not eq(Time.at(attributes[:time]))
        end
      end

      it 'does not send data to NewsChannel' do
        expect(ActionCable.server).to_not receive(:broadcast)
        update
      end

      it 'contains errors about invalid attributes' do
        expect(update[:errors]).to_not be_empty
      end

      it 'contain initial news object in result' do
        expect(update[:news]).to eq(news.reload)
      end
    end
  end

  describe "operations's result" do
    let(:attributes) do
      {}
    end

    let(:news) do
      FactoryBot.build(:news)
    end

    it 'returns Hash' do
      aggregate_failures 'result structure' do
        result = update
        expect(result).to have_key(:errors)
        expect(result).to have_key(:news)
      end
    end
  end
end
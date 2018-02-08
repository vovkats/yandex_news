require 'rails_helper'

describe Op::YandexNews::Save do
  let(:save) { described_class.execute(news, attributes) }

  let(:invalid_attributes) do
    {
        title: '',
        description: Faker::Lorem.sentence(3),
        time: 1518022111,
    }
  end

  let(:valid_attributes) do
    {
        title: Faker::Lorem.word,
        description: Faker::Lorem.sentence(3),
        time: 1518021127,
    }
  end

  shared_examples 'news is not created' do
    it 'does not create news' do
      expect{ save }.to_not change{ ::YaNews.count }
    end
  end

  context 'when news does not exist' do
    let(:news) { FactoryBot.build(:ya_news) }

    context 'and attributes are valid' do
      let(:attributes) { valid_attributes }

      it 'creates news' do
        expect{ save }.to change{ ::YaNews.count }.by(1)
      end
    end

    context 'and attributes are not valid' do
      let(:attributes) { invalid_attributes }

      include_examples 'news is not created'
    end
  end

  context 'when news has already existed' do
    let(:news) { FactoryBot.create(:ya_news, title: 'working title') }

    before do
      save
      news.reload
    end

    context 'and attributes are valid' do
      let(:attributes) { valid_attributes }

      it 'updates news' do
        aggregate_failures 'news attributes' do
          %i(title description).each do |attr_name|
            expect(news.public_send(attr_name)).to eq(attributes[attr_name])
          end

          expect(news.time).to eq(Time.at(attributes[:time]))
        end
      end

      include_examples 'news is not created'
    end

    context 'and attributes are not valid' do
      let(:attributes) { invalid_attributes }

      it 'does not update news' do
        aggregate_failures 'news attributes' do
          %i(title description time).each do |attr_name|
            expect(news.public_send(attr_name)).to_not eq(attributes[attr_name])
          end
        end
      end

      include_examples 'news is not created'
    end
  end

  describe "operations's result" do
    let(:attributes) do
      {}
    end

    let(:news) do
      FactoryBot.build(:ya_news)
    end

    it 'returns YandexNews object' do
      expect(save).to be_instance_of(::YaNews)
    end
  end


end
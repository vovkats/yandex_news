require 'rails_helper'

describe Op::AuthorsNews::Save do
  let(:save) { described_class.execute(news, attributes) }

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

  shared_examples 'news is not created' do
    it 'does not create news' do
      expect{ save }.to_not change{ ::News.count }
    end
  end

  context 'when news does not exist' do
    let(:news) { FactoryBot.build(:news) }

    context 'and attributes are valid' do
      let(:attributes) { valid_attributes }

      it 'creates news' do
        expect{ save }.to change{ News.count }.by(1)
      end

      it 'sends data to NewsChannel' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'news_channel',
          title: attributes[:title],
          description: attributes[:description],
          time: Time.at(attributes[:time])
        )

        save
      end
    end

    context 'and attributes are not valid' do
      let(:attributes) { invalid_attributes }

      it 'does not create news' do
        expect{ save }.to_not change{ News.count }
      end

      include_examples 'news is not created'
    end
  end

  context 'when news has already existed' do
    let(:news) { FactoryBot.create(:news, title: 'working title') }

    before do
      save
      news.reload
    end

    context 'and attributes are valid' do
      let(:attributes) { valid_attributes }

      it 'updates news' do
        aggregate_failures 'news attributes' do
          %i(title description show_until).each do |attr_name|
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
          %i(title description time show_until).each do |attr_name|
            expect(news.public_send(attr_name)).to_not eq(attributes[attr_name])
          end
        end
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

    it 'returns News object' do
      expect(save).to be_instance_of(::News)
    end
  end
end
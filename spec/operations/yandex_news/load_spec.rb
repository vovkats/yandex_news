require 'rails_helper'

describe Op::YandexNews::Load do
  let(:load) { described_class.execute }

  shared_examples 'broadcasting to NewsChannel' do
    it 'sends data to channel' do
      expect(ActionCable.server).to receive(:broadcast).with('news_channel',
        time: main_news[:time],
        title: main_news[:title],
        description: main_news[:description]
      )
      load
    end
  end

  shared_examples 'not broadcasting to NewsChannel' do
    it 'does not send data to channel' do
      expect(ActionCable.server).to_not receive(:broadcast)
      load
    end
  end

  context 'when the data has not retrieved from yandex' do
    before do
      allow(Op::YandexNews::Parse).to receive(:execute).and_return(
         { errors: ['some error'], news: []}
      )
    end

    it 'does not create yandex news' do
      expect { load }.to_not change { ::YaNews.count }
    end

    it 'returns information about parsed errors with not blank value' do
      expect(load[:errors][:parsed_errors]).to eq(['some error'])
    end

    include_examples 'not broadcasting to NewsChannel'
  end

  context 'when the data has retrieved from yandex is valid' do
    let(:news) do
      [
        {
          time: (Time.now - 10.seconds).to_i,
          title: 'title 1',
          description: 'description 1'
        },
        {
          time: (Time.now - 30.seconds).to_i,
          title: 'title 2',
          description: 'description 2'
        }
      ]
    end
    before do
      allow(Op::YandexNews::Parse).to receive(:execute).and_return(
        { errors: [],
          news: news
        }
      )
    end

    context 'and yandex news with such title exists' do
      let!(:ya_news) { FactoryBot.create(:ya_news, title: news.first[:title], main: false) }

      it 'does not create yandex news' do
        expect { load }.to_not change { ::YaNews.count }
      end

      it 'updates main field of existing yandex news' do
        load
        expect(ya_news.reload.main).to be_truthy
      end

      include_examples 'broadcasting to NewsChannel' do
        let(:main_news) do
          ya_news
        end
      end
    end

    context 'and yandex news with such title does not exist' do
      let!(:previous_ya_news) { FactoryBot.create(:ya_news, main: true) }

      it 'creates yandex news' do
        expect { load }.to change { ::YaNews.count }.by(1)
      end

      it 'updates main field of existing previous yandex news' do
        load
        expect(previous_ya_news.reload.main).to be_falsey
      end

      include_examples 'broadcasting to NewsChannel' do
        let(:main_news) do
          FactoryBot.build(:ya_news,
            title: news.first[:title],
            description: news.first[:description],
            time: Time.at(news.first[:time]))
        end
      end

      context 'and authors news exists' do
        let!(:authors_news) do
          FactoryBot.create(:news, show_until: Time.zone.now + 10.seconds)
        end

        it 'creates yandex news' do
          expect { load }.to change { ::YaNews.count }.by(1)
        end

        include_examples 'not broadcasting to NewsChannel'
      end
    end
  end

  context 'when the data has retrieved from yandex is invalid' do
    let(:news) do
      [
        {
          time: (Time.now - 10.seconds).to_i,
          title: 'title 1',
          description: ''
        },
        {
          time: (Time.now - 30.seconds).to_i,
          title: 'title 2',
          description: 'description 2'
        }
      ]
    end
    before do
      allow(Op::YandexNews::Parse).to receive(:execute).and_return(
          { errors: [],
            news: news
          }
      )
    end

    context 'and yandex news with such title exists' do
      let!(:ya_news) { FactoryBot.create(:ya_news, title: news.first[:title], main: false) }

      it 'does not create yandex news' do
        expect { load }.to_not change { ::YaNews.count }
      end

      it 'updates main field of existing yandex news' do
        load
        expect(ya_news.reload.main).to be_truthy
      end

      include_examples 'broadcasting to NewsChannel' do
        let(:main_news) do
          ya_news
        end
      end
    end

    context 'and yandex news with such title does not exist' do
      let!(:previous_ya_news) { FactoryBot.create(:ya_news, main: true) }

      it 'creates yandex news' do
        expect { load }.to change { ::YaNews.count }.by(1)
      end

      it 'updates main field of existing previous yandex news' do
        load
        expect(previous_ya_news.reload.main).to be_falsey
      end

      include_examples 'broadcasting to NewsChannel' do
        let(:main_news) do
          FactoryBot.build(:ya_news,
                           title: news.first[:title],
                           description: news.first[:description],
                           time: Time.at(news.first[:time]))
        end
      end

      context 'and authors news exists' do
        let!(:authors_news) do
          FactoryBot.create(:news, show_until: Time.zone.now + 10.seconds)
        end

        it 'creates yandex news' do
          expect { load }.to change { ::YaNews.count }.by(1)
        end

        include_examples 'not broadcasting to NewsChannel'
      end
    end
  end
end
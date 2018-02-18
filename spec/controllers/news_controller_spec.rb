require 'rails_helper'

describe NewsController do

  shared_examples 'authorized user' do
    it 'has filed "status" in json data' do
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to have_key(:status)
    end

    it 'returns news data in json data' do
      body = JSON.parse(response.body, symbolize_names: true)
      aggregate_failures 'news attributes' do
        %i(title description time show_until).each do |attr|
          expect(body[:data]).to have_key(attr)
        end
      end
    end

    it 'returns news data in json data' do
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to have_key(:errors)
    end
  end

  shared_examples 'unauthorized user' do
    it 'redirects on sing in page' do
      expect(subject).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is authorized' do

    before do
      sign_in create(:user)
    end

    describe '#show' do
      let!(:news) do
        create(:news, show_until: Time.zone.now + 10.seconds)
      end

      before { get :show }

      it_behaves_like 'authorized user'
    end

    describe '#create' do
      before do
        post :create, params: { news: { title: '1', description: '2' } }
      end

      it_behaves_like 'authorized user'
    end

    describe '#update' do
      let!(:news) do
        create(:news, show_until: Time.zone.now + 10.seconds)
      end

      before do
        post :update, params: { news: { title: '1', description: '2' } }
      end

      it_behaves_like 'authorized user'
    end
  end

  context 'when user is not authorized' do
    describe '#show' do
      subject { get :show }

      it_behaves_like 'unauthorized user'
    end

    describe '#create' do
      subject do
        post :create, params: { news: { title: '1', description: '2' } }
      end

      it_behaves_like 'unauthorized user'
    end

    describe '#update' do
      subject do
        post :update, params: { news: { title: '1', description: '2' } }
      end

      it_behaves_like 'unauthorized user'
    end
  end
end
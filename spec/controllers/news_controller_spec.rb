require 'rails_helper'

describe NewsController do

  before do
    sign_in create(:user)
  end

  shared_examples 'json news response' do
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

  describe '#show' do
    let!(:news) do
      create(:news, show_until: Time.zone.now + 10.seconds)
    end

    before do
      get :show
    end

    it_behaves_like 'json news response'
  end

  describe '#create' do
    before do
      post :create, params: { news: { title: '1', description: '2' } }
    end

    it_behaves_like 'json news response'
  end

  describe '#update' do
    let!(:news) do
      create(:news, show_until: Time.zone.now + 10.seconds)
    end

    before do
      post :update, params: { news: { title: '1', description: '2' } }
    end

    it_behaves_like 'json news response'
  end
end
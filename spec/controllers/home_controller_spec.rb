require 'rails_helper'

describe HomeController do

  describe '#show' do
    subject { get :show }

    it 'renders show page' do
      expect(subject).to render_template(:show)
    end
  end
end
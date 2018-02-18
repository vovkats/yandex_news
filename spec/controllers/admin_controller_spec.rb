require 'rails_helper'

describe AdminController do

  describe '#show' do
    subject { get :show }

    context 'when user is authorized' do
      before { sign_in(create(:user)) }

      it 'renders show page' do
        expect(subject).to render_template(:show)
      end
    end

    context 'when user is not authorized' do
      it 'redirects on sing in page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end
end
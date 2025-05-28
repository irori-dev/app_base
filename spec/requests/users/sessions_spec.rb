require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  describe 'POST /users/session' do
    let!(:user) { create(:user_core, password: 'password') }

    context 'with valid credentials' do
      it 'signs in user' do
        post users_session_path, params: { email: user.email, password: 'password' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(mypage_users_path)
      end
    end

    context 'with invalid credentials' do
      it 'renders new' do
        allow_any_instance_of(ActionView::Base).to receive(:stylesheet_link_tag).and_return('')
        post users_session_path, params: { email: user.email, password: 'wrong' }
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /users/session' do
    let!(:user) { create(:user_core, password: 'password') }

    before do
      post users_session_path, params: { email: user.email, password: 'password' }
    end

    it 'signs out user' do
      delete users_session_path
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end

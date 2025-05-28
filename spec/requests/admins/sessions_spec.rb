require 'rails_helper'

RSpec.describe 'Admins::Sessions', type: :request do
  describe 'POST /admins/session' do
    let!(:admin) { create(:admin, password: 'password') }

    context 'with valid credentials' do
      it 'signs in admin' do
        post admins_session_path, params: { email: admin.email, password: 'password' }
        expect(session[:admin_id]).to eq(admin.id)
        expect(response).to redirect_to(admins_users_path)
      end
    end

    context 'with invalid credentials' do
      it 'renders new' do
        allow_any_instance_of(ActionView::Base).to receive(:stylesheet_link_tag).and_return('')
        post admins_session_path, params: { email: admin.email, password: 'wrong' }
        expect(session[:admin_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /admins/session' do
    let!(:admin) { create(:admin, password: 'password') }

    before do
      post admins_session_path, params: { email: admin.email, password: 'password' }
    end

    it 'signs out admin' do
      delete admins_session_path
      expect(session[:admin_id]).to be_nil
      expect(response).to redirect_to(new_admins_session_path)
    end
  end
end

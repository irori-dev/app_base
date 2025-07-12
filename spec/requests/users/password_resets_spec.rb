require 'rails_helper'

RSpec.describe 'Users::PasswordResets', type: :request do
  let(:user) { create(:user_core) }

  describe 'GET /users/password_resets/new' do
    it 'returns success' do
      get new_users_password_reset_path
      expect(response).to have_http_status(:success)
    end

    it 'displays password reset form' do
      get new_users_password_reset_path
      expect(response.body).to include('パスワードを忘れた場合')
    end
  end

  describe 'POST /users/password_resets' do
    context 'with existing user email' do
      it 'creates a password reset' do
        expect do
          post users_password_resets_path, params: { email: user.email }
        end.to change(User::PasswordReset, :count).by(1)
      end

      it 'sends password reset email' do
        expect do
          post users_password_resets_path, params: { email: user.email }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'renders sent page' do
        post users_password_resets_path, params: { email: user.email }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('パスワード再設定ページのリンクをお送りしました')
      end
    end

    context 'with non-existing user email' do
      it 'does not create a password reset' do
        expect do
          post users_password_resets_path, params: { email: 'nonexistent@example.com' }
        end.not_to change(User::PasswordReset, :count)
      end

      it 'still renders sent page (security measure)' do
        post users_password_resets_path, params: { email: 'nonexistent@example.com' }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('パスワード再設定ページのリンクをお送りしました')
      end
    end
  end

  describe 'GET /users/password_resets/edit' do
    let(:password_reset) { create(:user_password_reset, user: user) }
    let(:token) { password_reset.token }

    it 'returns success with valid token' do
      get edit_users_password_reset_path(token: token)
      expect(response).to have_http_status(:success)
    end

    it 'displays password reset form' do
      get edit_users_password_reset_path(token: token)
      expect(response.body).to include('新しいパスワード')
    end
  end

  describe 'PATCH /users/password_resets' do
    let(:password_reset) { create(:user_password_reset, user: user) }
    let(:token) { password_reset.token }

    context 'with valid params' do
      let(:valid_params) do
        {
          token: token,
          password: 'newpassword123',
          password_confirmation: 'newpassword123',
        }
      end

      it 'updates user password' do
        expect do
          patch users_password_reset_path(token), params: valid_params
        end.to(change { user.reload.password_digest })
      end

      it 'marks password reset as used' do
        patch users_password_reset_path(token), params: valid_params
        expect(password_reset.reload.reset_at).not_to be_nil
      end

      it 'signs in the user' do
        patch users_password_reset_path(token), params: valid_params
        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to root with success message' do
        patch users_password_reset_path(token), params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('パスワードを更新し、ログインしました')
      end
    end

    context 'with password mismatch' do
      let(:invalid_params) do
        {
          token: token,
          password: 'newpassword123',
          password_confirmation: 'differentpassword',
        }
      end

      it 'does not update user password' do
        expect do
          patch users_password_reset_path(token), params: invalid_params
        end.not_to(change { user.reload.password_digest })
      end

      it 'renders edit with error' do
        patch users_password_reset_path(token), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('パスワードが一致しません')
      end
    end

    context 'with invalid token' do
      let(:invalid_params) do
        {
          token: 'invalid_token',
          password: 'newpassword123',
          password_confirmation: 'newpassword123',
        }
      end

      it 'does not update user password' do
        expect do
          patch users_password_reset_path('invalid_token'), params: invalid_params
        end.not_to(change { user.reload.password_digest })
      end

      it 'renders edit with error' do
        patch users_password_reset_path('invalid_token'), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('期限切れ、もしくは無効なトークンです')
      end
    end

    context 'with expired token' do
      let(:expired_reset) { create(:user_password_reset, user: user, created_at: 25.hours.ago) }
      let(:expired_token) { expired_reset.token }

      it 'does not update user password' do
        expect do
          patch users_password_reset_path(expired_token), params: {
            token: expired_token,
            password: 'newpassword123',
            password_confirmation: 'newpassword123',
          }
        end.not_to(change { user.reload.password_digest })
      end

      it 'renders edit with error' do
        patch users_password_reset_path(expired_token), params: {
          token: expired_token,
          password: 'newpassword123',
          password_confirmation: 'newpassword123',
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('期限切れ、もしくは無効なトークンです')
      end
    end

    context 'with already used token' do
      let(:used_reset) { create(:user_password_reset, user: user, reset_at: 1.hour.ago) }
      let(:used_token) { used_reset.token }

      it 'does not update user password' do
        expect do
          patch users_password_reset_path(used_token), params: {
            token: used_token,
            password: 'newpassword123',
            password_confirmation: 'newpassword123',
          }
        end.not_to(change { user.reload.password_digest })
      end

      it 'renders edit with error' do
        patch users_password_reset_path(used_token), params: {
          token: used_token,
          password: 'newpassword123',
          password_confirmation: 'newpassword123',
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('期限切れ、もしくは無効なトークンです')
      end
    end
  end
end

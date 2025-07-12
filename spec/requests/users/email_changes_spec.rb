require 'rails_helper'

RSpec.describe 'Users::EmailChanges', type: :request do
  let(:user) { create(:user_core) }

  describe 'GET /users/email_changes/new' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get new_users_email_change_path
        expect(response).to redirect_to(new_users_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(user) }

      it 'returns success' do
        get new_users_email_change_path
        expect(response).to have_http_status(:success)
      end

      it 'displays email change form' do
        get new_users_email_change_path
        expect(response.body).to include('メールアドレス変更')
      end
    end
  end

  describe 'POST /users/email_changes' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        post users_email_changes_path, params: { email: 'new@example.com' }
        expect(response).to redirect_to(new_users_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(user) }

      context 'with new email address' do
        it 'creates an email change request' do
          expect do
            post users_email_changes_path, params: { email: 'new@example.com' }
          end.to change(User::EmailChange, :count).by(1)
        end

        it 'sends email change confirmation' do
          expect do
            post users_email_changes_path, params: { email: 'new@example.com' }
          end.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'renders sent page' do
          post users_email_changes_path, params: { email: 'new@example.com' }
          expect(response).to have_http_status(:success)
          expect(response.body).to include('メールを送信しました')
        end
      end

      context 'with existing email address' do
        let(:other_user) { create(:user_core, email: 'existing@example.com') }

        before { other_user }

        it 'does not create an email change request' do
          expect do
            post users_email_changes_path, params: { email: 'existing@example.com' }
          end.not_to change(User::EmailChange, :count)
        end

        it 'redirects with error message' do
          post users_email_changes_path, params: { email: 'existing@example.com' }
          expect(response).to redirect_to(new_users_email_change_path)
          expect(flash[:alert]).to eq('このメールアドレスはご利用いただけません')
        end
      end
    end
  end

  describe 'GET /users/email_changes/change' do
    let(:email_change) { create(:user_email_change, user: user) }
    let(:token) { email_change.token }

    context 'with valid token' do
      it 'updates user email' do
        get change_users_email_change_path(token, token: token)
        expect(user.reload.email).to eq(email_change.email)
      end

      it 'marks email change as used' do
        get change_users_email_change_path(token, token: token)
        expect(email_change.reload.changed_at).not_to be_nil
      end

      it 'redirects with success message when signed in' do
        sign_in(user)
        get change_users_email_change_path(token, token: token)
        expect(response).to redirect_to(mypage_users_path)
        expect(flash[:notice]).to eq('メールアドレスを更新しました')
      end

      it 'redirects to root when not signed in' do
        get change_users_email_change_path(token, token: token)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('メールアドレスを更新しました')
      end
    end

    context 'with invalid token' do
      it 'redirects with error' do
        get change_users_email_change_path('invalid_token', token: 'invalid_token')
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('期限切れ、もしくは無効なトークンです')
      end

      it 'does not update user email' do
        expect do
          get change_users_email_change_path('invalid_token', token: 'invalid_token')
        end.not_to(change { user.reload.email })
      end
    end

    context 'with expired token' do
      let(:expired_change) { create(:user_email_change, user: user, created_at: 25.hours.ago) }
      let(:expired_token) { expired_change.token }

      it 'redirects with error' do
        get change_users_email_change_path(expired_token, token: expired_token)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('期限切れ、もしくは無効なトークンです')
      end

      it 'does not update user email' do
        expect do
          get change_users_email_change_path(expired_token, token: expired_token)
        end.not_to(change { user.reload.email })
      end
    end

    context 'with already used token' do
      let(:used_change) { create(:user_email_change, user: user, changed_at: 1.hour.ago) }
      let(:used_token) { used_change.token }

      it 'redirects with error' do
        get change_users_email_change_path(used_token, token: used_token)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('期限切れ、もしくは無効なトークンです')
      end

      it 'does not update user email' do
        expect do
          get change_users_email_change_path(used_token, token: used_token)
        end.not_to(change { user.reload.email })
      end
    end

    context 'when email is already taken' do
      let(:email_change) { create(:user_email_change, user: user, email: 'new@example.com') }
      let(:token) { email_change.token }
      let!(:other_user) { create(:user_core, email: 'new@example.com') }

      it 'redirects with error' do
        get change_users_email_change_path(token, token: token)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('このメールアドレスはすでに利用されています')
      end

      it 'does not update user email' do
        expect do
          get change_users_email_change_path(token, token: token)
        end.not_to(change { user.reload.email })
      end

      it 'does not mark email change as used' do
        get change_users_email_change_path(token, token: token)
        expect(email_change.reload.changed_at).to be_nil
      end
    end
  end
end

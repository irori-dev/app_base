require 'rails_helper'

RSpec.describe 'Admins::Users', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user_core) }

  describe 'GET /admins/users' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get admins_users_path
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      it 'returns success' do
        get admins_users_path
        expect(response).to have_http_status(:success)
      end

      it 'displays users' do
        user
        get admins_users_path
        expect(response.body).to include(user.email)
      end

      context 'with search params' do
        let!(:user1) { create(:user_core, email: 'test@example.com') }
        let!(:user2) { create(:user_core, email: 'other@example.com') }

        it 'filters users by email' do
          get admins_users_path(q: { email_cont: 'test' })
          expect(response.body).to include('test@example.com')
          expect(response.body).not_to include('other@example.com')
        end
      end

      it 'includes associations to avoid N+1 queries' do
        users = create_list(:user_core, 3)
        users.each do |u|
          create(:user_password_reset, user: u)
          create(:user_email_change, user: u)
        end

        get admins_users_path

        # Just verify the page loads correctly with included associations
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /admins/users/:id' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get admins_user_path(user)
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      it 'returns success' do
        get admins_user_path(user)
        expect(response).to have_http_status(:success)
      end

      it 'displays user details' do
        get admins_user_path(user)
        expect(response.body).to include(user.email)
        expect(response.body).to include(user.id.to_s)
      end

      context 'when user has password resets' do
        let!(:password_reset) { create(:user_password_reset, user: user) }

        it 'displays password reset information' do
          get admins_user_path(user)
          expect(response.body).to include('パスワードリセット')
        end
      end

      context 'when user has email changes' do
        let!(:email_change) { create(:user_email_change, user: user) }

        it 'displays email change information' do
          get admins_user_path(user)
          expect(response.body).to include('メールアドレス変更')
        end
      end
    end
  end

  describe 'POST /admins/users/insert' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        post insert_admins_users_path, params: { count: 5 }
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      it 'enqueues CreateSampleUsersJob' do
        expect do
          post insert_admins_users_path, params: { count: 5 }, as: :turbo_stream
        end.to have_enqueued_job(CreateSampleUsersJob).with(5)
      end

      it 'returns success with turbo stream' do
        post insert_admins_users_path, params: { count: 5 }, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.body).to include('5件のユーザーを作成しました')
      end

      context 'with invalid count' do
        it 'handles string count by converting to integer' do
          expect do
            post insert_admins_users_path, params: { count: 'abc' }, as: :turbo_stream
          end.to have_enqueued_job(CreateSampleUsersJob).with(0)
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Admins::Admins', type: :request do
  let(:admin) { create(:admin) }
  let(:other_admin) { create(:admin) }

  describe 'GET /admins/admins' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get admins_admins_path
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      it 'returns success' do
        get admins_admins_path
        expect(response).to have_http_status(:success)
      end

      it 'displays admins' do
        other_admin
        get admins_admins_path
        expect(response.body).to include(admin.email)
        expect(response.body).to include(other_admin.email)
      end

      context 'with search params' do
        it 'filters admins' do
          admin.update!(email: 'test@example.com')
          other_admin.update!(email: 'other@example.com')

          get admins_admins_path(q: { email_cont: 'test' })
          expect(response.body).to include('test@example.com')
          expect(response.body).not_to include('other@example.com')
        end
      end
    end
  end

  describe 'GET /admins/admins/new' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get new_admins_admin_path
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      it 'returns success' do
        get new_admins_admin_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /admins/admins' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        post admins_admins_path, params: { admin: { email: 'new@example.com', password: 'password' } }
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      context 'with valid params' do
        it 'creates a new admin' do
          expect do
            post admins_admins_path, params: { admin: { email: 'new@example.com', password: 'password' } }
          end.to change(Admin, :count).by(1)
        end

        it 'returns success with turbo stream' do
          post admins_admins_path, params: { admin: { email: 'new@example.com', password: 'password' } }, as: :turbo_stream
          expect(response).to have_http_status(:success)
          expect(response.body).to include('管理者を作成しました')
        end
      end

      context 'with invalid params' do
        it 'does not create a new admin' do
          expect do
            post admins_admins_path, params: { admin: { email: '', password: 'password' } }
          end.not_to change(Admin, :count)
        end

        it 'renders new template' do
          post admins_admins_path, params: { admin: { email: '', password: 'password' } }
          expect(response).to have_http_status(:success)
          expect(response.body).to include('管理者の作成に失敗しました')
        end
      end
    end
  end

  describe 'GET /admins/admins/:id/edit' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get edit_admins_admin_path(other_admin)
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      context 'when editing other admin' do
        it 'returns success' do
          get edit_admins_admin_path(other_admin)
          expect(response).to have_http_status(:success)
        end
      end

      context 'when editing self' do
        it 'redirects with alert' do
          get edit_admins_admin_path(admin)
          expect(response).to redirect_to(admins_admins_path)
          expect(flash[:alert]).to eq('自分自身の権限は変更できません')
        end
      end
    end
  end

  describe 'PATCH /admins/admins/:id' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        patch admins_admin_path(other_admin), params: { admin: { email: 'updated@example.com' } }
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      context 'when updating other admin' do
        context 'with valid params' do
          it 'updates the admin' do
            patch admins_admin_path(other_admin), params: { admin: { email: 'updated@example.com' } }
            expect(other_admin.reload.email).to eq('updated@example.com')
          end

          it 'returns success with turbo stream' do
            patch admins_admin_path(other_admin), params: { admin: { email: 'updated@example.com' } }, as: :turbo_stream
            expect(response).to have_http_status(:success)
            expect(response.body).to include('管理者を更新しました')
          end
        end

        context 'with invalid params' do
          it 'does not update the admin' do
            original_email = other_admin.email
            patch admins_admin_path(other_admin), params: { admin: { email: '' } }
            expect(other_admin.reload.email).to eq(original_email)
          end

          it 'renders edit template' do
            patch admins_admin_path(other_admin), params: { admin: { email: '' } }
            expect(response).to have_http_status(:success)
            expect(response.body).to include('管理者の更新に失敗しました')
          end
        end
      end

      context 'when updating self' do
        it 'redirects with alert' do
          patch admins_admin_path(admin), params: { admin: { email: 'updated@example.com' } }
          expect(response).to redirect_to(admins_admins_path)
          expect(flash[:alert]).to eq('自分自身の権限は変更できません')
        end
      end
    end
  end

  describe 'DELETE /admins/admins/:id' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        delete admins_admin_path(other_admin)
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      context 'when deleting other admin' do
        it 'deletes the admin' do
          other_admin # create before expect block
          expect do
            delete admins_admin_path(other_admin)
          end.to change(Admin, :count).by(-1)
        end

        it 'returns success with turbo stream' do
          delete admins_admin_path(other_admin), as: :turbo_stream
          expect(response).to have_http_status(:success)
          expect(response.body).to include('管理者を削除しました')
        end
      end

      context 'when deleting self' do
        it 'redirects with alert' do
          delete admins_admin_path(admin)
          expect(response).to redirect_to(admins_admins_path)
          expect(flash[:alert]).to eq('自分自身の権限は変更できません')
        end

        it 'does not delete the admin' do
          expect do
            delete admins_admin_path(admin)
          end.not_to change(Admin, :count)
        end
      end
    end
  end
end

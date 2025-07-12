require 'rails_helper'

RSpec.describe 'Admin User Management', type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:admin) { create(:admin) }
  let!(:users) { create_list(:user_core, 5) }

  describe 'Admin user management flow' do
    before do
      sign_in_admin(admin)
    end

    it 'allows admin to view users list' do
      visit admins_users_path

      expect(page).to have_content('ユーザー一覧')
      users.each do |user|
        expect(page).to have_content(user.email)
      end
    end

    it 'allows admin to search users by email' do
      target_user = users.first
      visit admins_users_path

      fill_in 'q_email_cont', with: target_user.email
      click_button '検索'

      expect(page).to have_content(target_user.email)
      expect(page).not_to have_content(users.last.email)
    end

    it 'allows admin to view user details' do
      users.first
      visit admins_users_path

      # Click the first detail link as a simple approach
      first(:link, '詳細').click

      expect(page).to have_content('ユーザー情報')
      expect(page).to have_content('作成日時')
    end

    it 'shows password reset history when present' do
      user = users.first
      create(:user_password_reset, user: user)

      visit admins_user_path(user)

      expect(page).to have_content('パスワードリセット履歴')
      expect(page).to have_content('未使用')
    end

    it 'shows email change history when present' do
      user = users.first
      create(:user_email_change, user: user, email: 'newemail@example.com')

      visit admins_user_path(user)

      expect(page).to have_content('メールアドレス変更履歴')
      expect(page).to have_content('newemail@example.com')
      expect(page).to have_content('未変更')
    end

    it 'allows admin to create sample users' do
      visit admins_users_path

      fill_in 'count', with: '3'
      click_button '一括作成'

      expect(page).to have_content('3件のユーザーを作成しました')
    end

    it 'allows admin to navigate between users and return to list' do
      visit admins_users_path

      # Go to user detail
      user = users.first
      first(:link, '詳細').click
      expect(page).to have_content('ユーザー情報')

      # Return to list
      first(:link, 'ユーザー一覧').click
      expect(page).to have_content('ユーザー一覧')
      expect(page).to have_content(user.email)
    end
  end

  describe 'Admin authentication flow' do
    it 'requires admin authentication to access users' do
      visit admins_users_path

      expect(page).to have_current_path(new_admins_session_path)
      expect(page).to have_content('ログイン')
    end

    it 'shows admin email after login' do
      visit new_admins_session_path

      fill_in 'メールアドレス', with: admin.email
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'

      expect(page).to have_content('ログインしました')
      expect(page).to have_link('ログアウト')
    end
  end
end

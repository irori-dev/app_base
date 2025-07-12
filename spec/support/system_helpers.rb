module SystemHelpers

  def sign_in(user)
    visit new_users_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  def sign_in_admin(admin)
    visit new_admins_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

end

RSpec.configure do |config|
  config.include SystemHelpers, type: :system
end

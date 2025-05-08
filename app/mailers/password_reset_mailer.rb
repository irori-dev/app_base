class PasswordResetMailer < ApplicationMailer

  def for_user(password_reset)
    @password_reset = password_reset
    mail to: password_reset.user.email, subject: 'パスワード再設定の確認'
  end

end

class PasswordResetMailer < ApplicationMailer
  def for_user(password_reset)
    @password_reset = password_reset
    mail to: password_reset.user.email, subject: "\u30D1\u30B9\u30EF\u30FC\u30C9\u518D\u8A2D\u5B9A\u306E\u78BA\u8A8D"
  end
end

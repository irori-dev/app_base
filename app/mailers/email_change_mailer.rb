class EmailChangeMailer < ApplicationMailer
  def for_user(email_change)
    @email_change = email_change
    mail to: email_change.email, subject: "メールアドレス変更の確認"
  end
end

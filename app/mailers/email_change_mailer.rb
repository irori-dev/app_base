class EmailChangeMailer < ApplicationMailer
  def for_user(email_change)
    @email_change = email_change
    mail to: email_change.email, subject: "\u30E1\u30FC\u30EB\u30A2\u30C9\u30EC\u30B9\u5909\u66F4\u306E\u78BA\u8A8D"
  end
end

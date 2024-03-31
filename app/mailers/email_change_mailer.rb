class EmailChangeMailer < ApplicationMailer
  def for_changeable(email_change)
    if Rails.env.in? %w[staging production]
      request = for_changeable_request(email_change)
      Mail::Sendgrid.new.send(request)
    else
      @email_change = email_change
      mail to: email_change.email, subject: 'メールアドレス変更の確認'
    end
  end

  private

  def for_changeable_request(email_change)
    request = { template_id: Rails.application.credentials.dig(:sendgrid, :template_id, :email_change_for_changeable) }
    request[:from] = from_params
    request[:personalizations] =
      [
        {
          to: [{ email: email_change.email }],
          dynamic_template_data: {
            url: Rails.application.routes.url_helpers.change_users_email_change_url(email_change.change_token)
          }
        }
      ]
    request
  end
end

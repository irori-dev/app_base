class PasswordResetMailer < ApplicationMailer
  def for_resettable(password_reset)
    if Rails.env.in? %w[staging production]
      request = for_resettable_request(password_reset)
      Mail::Sendgrid.new.send(request)
    else
      @password_reset = password_reset
      mail to: password_reset.password_resettable.email, subject: 'パスワード再設定の確認'
    end
  end

  private

  def for_resettable_request(password_reset)
    request = { template_id: Rails.application.credentials.dig(:sendgrid, :template_id,
                                                               :password_reset_for_resettable) }
    request[:from] = from_params
    url = if password_reset.password_resettable_type == 'User'
            Rails.application.routes.url_helpers.edit_users_password_reset_url(password_reset.reset_token)
          else
            Rails.application.routes.url_helpers.edit_admins_password_reset_url(password_reset.reset_token)
          end
    request[:personalizations] =
      [
        {
          to: [{ email: password_reset.password_resettable.email }],
          dynamic_template_data: {
            url:
          }
        }
      ]
    request
  end
end

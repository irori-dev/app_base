require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  if Rails.env.in?(%w[staging production])
    config.add_notifier :slack, {
      webhook_url: Rails.application.credentials.dig(:slack, :webhook_url),
    }
  end
end

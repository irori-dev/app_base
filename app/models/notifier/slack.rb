class Notifier::Slack
  attr_accessor :client

  def initialize
    @client = ::Slack::Notifier.new(Rails.application.credentials.dig(:slack, :webhook_url))
  end

  def send(message)
    @client.ping(message)
  end
end

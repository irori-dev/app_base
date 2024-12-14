class UserCreationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_creation_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

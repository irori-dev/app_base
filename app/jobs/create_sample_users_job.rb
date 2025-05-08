class CreateSampleUsersJob < ApplicationJob

  def perform(*args)
    count = args[0]
    chars = ('a'..'z').to_a
    count.times do |_i|
      user = User::Core.create(email: "#{8.times.map { chars.sample }.join}@example.com", password: 'password')
      ActionCable.server.broadcast 'user_creation_channel', { user: render_user_card(user) }
      sleep 3
    end
  end

  private

  def render_user_card(user)
    ApplicationController.renderer.render(
      Admins::UserCard::Component.new(user:),
      layout: false
    )
  end

end

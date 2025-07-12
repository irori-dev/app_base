module AuthenticationHelpers

  def sign_in(resource)
    if resource.is_a?(Admin)
      post admins_session_path, params: { email: resource.email, password: 'password' }
    elsif resource.is_a?(User::Core)
      post users_session_path, params: { email: resource.email, password: 'password' }
    else
      raise "Unknown resource type: #{resource.class}"
    end
  end

end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end

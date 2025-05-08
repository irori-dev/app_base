class Navbar::Component < ViewComponent::Base

  include Turbo::FramesHelper

  def initialize(current_user:)
    @current_user = current_user
  end

end

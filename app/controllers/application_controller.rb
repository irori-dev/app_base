class ApplicationController < ActionController::Base
  private

  def current_user
    return unless session[:uid]

    @current_user = User.find_by(uid: session[:uid])
  end

  def require_user!
    return if current_user

    redirect_to login_path
  end
end

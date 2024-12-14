class ApplicationController < ActionController::Base
  before_action :prepare_exception_notifier

  private

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user:,
      app: "AppBase"
    }
  end

  def require_user!
    redirect_to new_users_session_path unless user_signed_in?
  end

  def require_not_user!
    return unless user_signed_in?

    flash[:alert] = "既にログインしています"
    redirect_to root_path
  end

  def current_user
    @current_user ||= User::Core.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end
end

class ApplicationController < ActionController::Base
  include Authenticatable

  before_action :prepare_exception_notifier

  private

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user:,
      app: 'AppBase',
    }
  end

  # Authenticatable concern methods
  alias require_user! require_resource!
  alias current_user current_resource
  alias user_signed_in? resource_signed_in?

  def require_not_user!
    return unless user_signed_in?

    flash[:alert] = '既にログインしています'
    redirect_to root_path
  end

  def resource_class
    User::Core
  end

  def session_key
    :user_id
  end

  def sign_in_path
    new_users_session_path
  end

  def after_sign_in_path
    root_path
  end

end

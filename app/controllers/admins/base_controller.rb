class Admins::BaseController < ApplicationController

  before_action :prepare_exception_notifier
  before_action :require_admin!

  layout 'admins'

  private

  def require_admin!
    redirect_to Rails.application.routes.url_helpers.new_admins_session_path unless admin_signed_in?
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end
  helper_method :current_admin

  def admin_signed_in?
    current_admin.present?
  end

  def sign_in(admin)
    session[:admin_id] = admin.id
  end

  def sign_out
    session.delete(:admin_id)
    @current_admin = nil
  end

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_admin_id: current_admin&.id,
    }
  end

end

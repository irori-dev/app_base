class Admins::BaseController < ApplicationController
  include Authenticatable

  before_action :prepare_exception_notifier
  before_action :require_admin!

  layout 'admins'

  private

  # Authenticatable concern methods
  alias require_admin! require_resource!
  alias current_admin current_resource
  alias admin_signed_in? resource_signed_in?

  def resource_class
    Admin
  end

  def session_key
    :admin_id
  end

  def sign_in_path
    Rails.application.routes.url_helpers.new_admins_session_path
  end

  def after_sign_in_path
    Rails.application.routes.url_helpers.admins_root_path
  end

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_admin_id: current_admin&.id,
    }
  end

end

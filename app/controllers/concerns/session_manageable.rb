# frozen_string_literal: true

module SessionManageable

  extend ActiveSupport::Concern

  included do
    skip_before_action :require_user!, only: %i[new create] if defined?(Users::BaseController) && self < Users::BaseController
    skip_before_action :require_admin!, only: %i[new create] if defined?(Admins::BaseController) && self < Admins::BaseController
  end

  def new; end

  def create
    resource = resource_class.find_by(email: session_params[:email])
    if resource&.authenticate(session_params[:password])
      sign_in_resource(resource)
      flash[:notice] = 'ログインしました'
      redirect_to after_sign_in_path
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが違います'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out_resource
    flash[:notice] = 'ログアウトしました'
    redirect_to after_sign_out_path
  end

  private

  def session_params
    params.permit(:email, :password)
  end

  def resource_class
    if is_a?(Admins::BaseController)
      Admin
    elsif is_a?(Users::BaseController)
      User::Core
    else
      raise NotImplementedError, "#{self.class} must define resource_class"
    end
  end

  def after_sign_out_path
    if is_a?(Admins::BaseController)
      new_admins_session_path
    else
      root_path
    end
  end

  def after_sign_in_path
    raise NotImplementedError, "#{self.class} must define after_sign_in_path"
  end

  def sign_in_resource(resource)
    sign_in(resource)
  end

  def sign_out_resource
    sign_out # Both controllers have sign_out method
  end

end

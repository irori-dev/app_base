# frozen_string_literal: true

module SessionManageable
  extend ActiveSupport::Concern

  included do
    skip_before_action :require_resource!, only: %i[new create]
  end

  def new; end

  def create
    resource = resource_class.find_by(email: params[:email])
    if resource&.authenticate(params[:password])
      sign_in(resource)
      flash[:notice] = 'ログインしました'
      redirect_to after_sign_in_path
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが違います'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    flash[:notice] = 'ログアウトしました'
    redirect_to after_sign_out_path
  end

  private

  def after_sign_out_path
    sign_in_path
  end
end
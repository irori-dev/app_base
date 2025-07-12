class Users::PasswordResetsController < Users::BaseController

  skip_before_action :require_user!, only: %i[new create edit update]

  layout 'narrow'

  def new; end

  def create
    user = User::Core.find_by(email: create_params[:email])
    if user.present?
      password_reset = user.password_resets.create!
      password_reset.send_password_reset_email
    end

    render :sent
  end

  def edit; end

  def update
    raise 'パスワードが一致しません' if update_params[:password] != update_params[:password_confirmation]

    password_reset = User::PasswordReset.not_expired.not_reset.detected_by(update_params[:token])
    raise '期限切れ、もしくは無効なトークンです' if password_reset.blank?

    ActiveRecord::Base.transaction do
      password_reset.user.update!(password: update_params[:password])
      password_reset.reset!
    end

    sign_in(password_reset.user)
    redirect_to root_path, notice: 'パスワードを更新し、ログインしました'
  rescue StandardError => e
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end

  private

  def create_params
    params.permit(:email)
  end

  def update_params
    params.permit(:password, :password_confirmation, :token)
  end

end

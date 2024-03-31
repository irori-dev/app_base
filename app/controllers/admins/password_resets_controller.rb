class Admins::PasswordResetsController < Admins::BaseController
  skip_before_action :require_admin!, only: %i[new create edit update sent]

  layout 'simple'

  def new; end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin.present?
      password_reset = admin.password_resets.create!
      password_reset.send_password_reset_email
    end

    redirect_to sent_admins_password_resets_path
  end

  def sent; end

  def edit; end

  def update
    raise 'パスワードが一致しません' if params[:password] != params[:password_confirmation]

    password_reset = PasswordReset.not_expired.not_reset.detected_by(params[:token])
    password_resettable = password_reset&.password_resettable
    raise '期限切れ、もしくは無効なトークンです' if password_reset.blank? || password_resettable.class.name != 'Admin'

    ActiveRecord::Base.transaction do
      password_resettable.update!(password: params[:password])
      password_reset.reset!
    end

    sign_in(password_resettable)
    redirect_to admins_users_path, notice: 'パスワードを更新し、ログインしました'
  rescue StandardError => e
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end
end

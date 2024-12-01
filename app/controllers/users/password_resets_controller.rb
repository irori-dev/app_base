class Users::PasswordResetsController < Users::BaseController
  skip_before_action :require_user!, only: %i[new create edit update]

  layout "narrow"

  def new; end

  def create
    user = User::Core.find_by(email: params[:email])
    if user.present?
      password_reset = user.password_resets.create!
      password_reset.send_password_reset_email
    end

    render :sent
  end

  def edit; end

  def update
    raise "\u30D1\u30B9\u30EF\u30FC\u30C9\u304C\u4E00\u81F4\u3057\u307E\u305B\u3093" if params[:password] != params[:password_confirmation]

    password_reset = User::PasswordReset.not_expired.not_reset.detected_by(params[:token])
    raise "\u671F\u9650\u5207\u308C\u3001\u3082\u3057\u304F\u306F\u7121\u52B9\u306A\u30C8\u30FC\u30AF\u30F3\u3067\u3059" if password_reset.blank?

    ActiveRecord::Base.transaction do
      password_reset.user.update!(password: params[:password])
      password_reset.reset!
    end

    sign_in(password_reset.user)
    redirect_to root_path, notice: "\u30D1\u30B9\u30EF\u30FC\u30C9\u3092\u66F4\u65B0\u3057\u3001\u30ED\u30B0\u30A4\u30F3\u3057\u307E\u3057\u305F"
  rescue StandardError => e
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end
end

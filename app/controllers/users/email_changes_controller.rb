class Users::EmailChangesController < Users::BaseController
  skip_before_action :require_user!, only: %i[change]

  layout 'narrow'

  def new; end

  def create
    if User.exists?(email: params[:email])
      redirect_to new_users_email_change_path,
                  alert: 'このメールアドレスはご利用いただけません' and return
    end

    email_change = current_user.email_changes.create!(email: params[:email])
    email_change.send_email_changed_email

    redirect_to sent_users_email_changes_path
  end

  def sent; end

  def change
    email_change = EmailChange.not_expired.not_changed.detected_by(params[:token])
    email_changeable = email_change&.email_changeable
    raise '期限切れ、もしくは無効なトークンです' if email_change.blank? || email_changeable.class.name != 'User'
    raise 'このメールアドレスはすでに利用されています' if User.exists?(email: email_change.email)

    ActiveRecord::Base.transaction do
      email_changeable.update!(email: email_change.email)
      email_change.change!
    end

    path = current_user.present? ? users_mypage_path : root_path
    redirect_to path, notice: 'メールアドレスを更新しました'
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to root_path
  end
end

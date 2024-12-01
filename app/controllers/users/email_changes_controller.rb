class Users::EmailChangesController < Users::BaseController
  skip_before_action :require_user!, only: %i[change]

  layout "narrow"

  def new; end

  def create
    if User::Core.exists?(email: params[:email])
      redirect_to new_users_email_change_path,
                  alert: "\u3053\u306E\u30E1\u30FC\u30EB\u30A2\u30C9\u30EC\u30B9\u306F\u3054\u5229\u7528\u3044\u305F\u3060\u3051\u307E\u305B\u3093" and return
    end

    email_change = current_user.email_changes.create!(email: params[:email])
    email_change.send_email_changed_email

    render :sent
  end

  def change
    email_change = User::EmailChange.not_expired.not_changed.detected_by(params[:token])
    raise "\u671F\u9650\u5207\u308C\u3001\u3082\u3057\u304F\u306F\u7121\u52B9\u306A\u30C8\u30FC\u30AF\u30F3\u3067\u3059" if email_change.blank?
    raise "\u3053\u306E\u30E1\u30FC\u30EB\u30A2\u30C9\u30EC\u30B9\u306F\u3059\u3067\u306B\u5229\u7528\u3055\u308C\u3066\u3044\u307E\u3059" if User::Core.exists?(email: email_change.email)

    ActiveRecord::Base.transaction do
      email_change.change!
    end

    path = current_user.present? ? mypage_users_path : root_path
    redirect_to path, notice: "\u30E1\u30FC\u30EB\u30A2\u30C9\u30EC\u30B9\u3092\u66F4\u65B0\u3057\u307E\u3057\u305F"
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to root_path
  end
end

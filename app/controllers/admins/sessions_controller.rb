class Admins::SessionsController < Admins::BaseController
  skip_before_action :require_admin!, only: %i[new create]

  layout "narrow"

  def new; end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      sign_in(admin)
      flash[:notice] = "ログインしました"
      redirect_to admins_users_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    flash[:notice] = "ログアウトしました"
    redirect_to new_admins_session_path
  end
end

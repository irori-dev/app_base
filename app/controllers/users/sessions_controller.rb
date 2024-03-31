class Users::SessionsController < Users::BaseController
  skip_before_action :require_user!, only: %i[new create]

  layout 'narrow'

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      sign_in(user)
      flash[:notice] = 'ログインしました'
      redirect_to root_path
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが違います'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    flash[:notice] = 'ログアウトしました'
    redirect_to root_path
  end
end

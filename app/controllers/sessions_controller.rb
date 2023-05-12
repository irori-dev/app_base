class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(uid: permit_params[:uid])
    if user&.authenticate(permit_params[:password])
      session[:uid] = user.uid
      redirect_to root_path
    else
      redirect_to login_path
      flash.notice = 'IDまたはパスワードが間違っています。'
    end
  end

  private

  def permit_params
    params.require(:user).permit(:uid, :password)
  end
end

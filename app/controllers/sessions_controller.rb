class SessionsController < ApplicationController
  def index; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    user = User.find_by(uid: params[:user][:uid])
    if user&.authenticate(params[:user][:password])
      session[:uid] = user.uid
      redirect_to root_path
    else
      redirect_to login_path
      flash.notice = 'IDまたはパスワードが間違っています。'
    end
  end

  def update; end

  def destroy
    flash.now.notice = 'ログアウトしました。'
  end

  private

  def user_params
    params.require(:user).permit(:uid, :password)
  end
end

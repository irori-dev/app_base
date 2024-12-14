class UsersController < ApplicationController
  before_action :require_not_user!, only: %i[new create]
  before_action :require_user!, only: %i[mypage]

  layout "users"

  def new
    @user = User::Core.new
  end

  def create
    @user = User::Core.new(permitted_params)

    if @user.save
      sign_in(@user)
      flash.now[:notice] = "ユーザー登録が完了しました"
    else
      render :new
    end
  end

  def mypage; end

  private

  def permitted_params
    params.require(:user_core).permit(:email, :password)
  end
end

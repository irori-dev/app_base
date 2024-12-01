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
      flash.now[:notice] = "\u767B\u9332\u304C\u5B8C\u4E86\u3057\u3001\u30ED\u30B0\u30A4\u30F3\u3057\u307E\u3057\u305F"
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

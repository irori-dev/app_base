class Admins::UsersController < Admins::BaseController
  def index
    @search = User::Core.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?

    @users = @search.result.page(params[:page])
  end

  def show
    @user = User::Core.find(params[:id])
  end
end

class Admins::UsersController < Admins::BaseController
  def index
    @search = User.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?

    @users = @search.result.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end

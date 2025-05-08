class Admins::UsersController < Admins::BaseController

  def index
    @search = User::Core.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?

    @users = @search.result.page(params[:page])
  end

  def show
    @user = User::Core.find(params[:id])
  end

  def insert
    count = params[:count].to_i
    CreateSampleUsersJob.perform_later(count)
    flash.now[:notice] = "#{count}件のユーザーを作成しました"
  end

end

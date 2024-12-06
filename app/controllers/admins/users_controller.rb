class Admins::UsersController < Admins::BaseController
  def index
    @search = User::Core.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?

    @users = @search.result.page(params[:page])
  end

  def show
    @user = User::Core.find(params[:id])
  end

  def insert
    count = params[:count].to_i
    CreateSampleUsersJob.perform_later(count)
    redirect_to admins_users_path, notice: "Creating #{count} users..."
  end

  def update_time
    puts "update_time"
    AdminChannel.broadcast_to(current_admin, admin: current_admin)
  end
end

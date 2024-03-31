class Admins::AdminsController < Admins::BaseController
  before_action :require_not_current_admin!, only: %i[edit update destroy]

  def index
    @search = Admin.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?

    @admins = @search.result.page(params[:page])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(create_params)
    @admin.save!
    flash.now[:notice] = '管理者を作成しました'
  rescue StandardError
    flash.now[:alert] = '管理者の作成に失敗しました'
    render :new
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    @admin.update!(update_params)
    flash.now[:notice] = '管理者を更新しました'
  rescue StandardError
    flash.now[:alert] = '管理者の更新に失敗しました'
    render :edit
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy!
    flash.now[:notice] = '管理者を削除しました'
  rescue StandardError
    flash.now[:alert] = '管理者の削除に失敗しました'
    render :index
  end

  private

  def require_not_current_admin!
    return unless current_admin == Admin.find(params[:id])

    flash[:alert] = '自分自身の権限は変更できません'
    redirect_to admins_admins_path
  end

  def create_params
    params.require(:admin).permit(:email, :password)
  end

  def update_params
    params.require(:admin).permit(:email)
  end
end

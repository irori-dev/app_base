class Admins::AdminsController < Admins::BaseController
  before_action :require_not_current_admin!, only: %i[edit update destroy]

  def index
    @search = Admin.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?

    @admins = @search.result.page(params[:page])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(create_params)
    @admin.save!
    flash.now[:notice] = "\u7BA1\u7406\u8005\u3092\u4F5C\u6210\u3057\u307E\u3057\u305F"
  rescue StandardError
    flash.now[:alert] = "\u7BA1\u7406\u8005\u306E\u4F5C\u6210\u306B\u5931\u6557\u3057\u307E\u3057\u305F"
    render :new
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    @admin.update!(update_params)
    flash.now[:notice] = "\u7BA1\u7406\u8005\u3092\u66F4\u65B0\u3057\u307E\u3057\u305F"
  rescue StandardError
    flash.now[:alert] = "\u7BA1\u7406\u8005\u306E\u66F4\u65B0\u306B\u5931\u6557\u3057\u307E\u3057\u305F"
    render :edit
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy!
    flash.now[:notice] = "\u7BA1\u7406\u8005\u3092\u524A\u9664\u3057\u307E\u3057\u305F"
  rescue StandardError
    flash.now[:alert] = "\u7BA1\u7406\u8005\u306E\u524A\u9664\u306B\u5931\u6557\u3057\u307E\u3057\u305F"
    render :index
  end

  private

  def require_not_current_admin!
    return unless current_admin == Admin.find(params[:id])

    flash[:alert] = "\u81EA\u5206\u81EA\u8EAB\u306E\u6A29\u9650\u306F\u5909\u66F4\u3067\u304D\u307E\u305B\u3093"
    redirect_to admins_admins_path
  end

  def create_params
    params.require(:admin).permit(:email, :password)
  end

  def update_params
    params.require(:admin).permit(:email)
  end
end

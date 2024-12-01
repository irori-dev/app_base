class Admins::SessionsController < Admins::BaseController
  skip_before_action :require_admin!, only: %i[new create]

  layout "narrow"

  def new; end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      sign_in(admin)
      flash[:notice] = "\u30ED\u30B0\u30A4\u30F3\u3057\u307E\u3057\u305F"
      redirect_to admins_users_path
    else
      flash.now[:alert] = "\u30E1\u30FC\u30EB\u30A2\u30C9\u30EC\u30B9\u307E\u305F\u306F\u30D1\u30B9\u30EF\u30FC\u30C9\u304C\u9055\u3044\u307E\u3059"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    flash[:notice] = "\u30ED\u30B0\u30A2\u30A6\u30C8\u3057\u307E\u3057\u305F"
    redirect_to new_admins_session_path
  end
end

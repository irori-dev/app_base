class Users::SessionsController < Users::BaseController

  include SessionManageable

  private

  def after_sign_in_path
    mypage_users_path
  end

  def after_sign_out_path
    root_path
  end

end

class Admins::SessionsController < Admins::BaseController

  include SessionManageable

  layout 'narrow'

  private

  def after_sign_in_path
    admins_users_path
  end

end

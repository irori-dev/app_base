class Users::BaseController < ApplicationController
  before_action :require_user!

  layout 'default'
end

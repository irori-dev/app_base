class ApplicationController < ActionController::Base
  before_action :prepare_exception_notifier

  private

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user:,
      app: 'AppBase'
    }
  end

  def current_user
    nil
  end
end

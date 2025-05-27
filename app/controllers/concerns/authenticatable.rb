# frozen_string_literal: true

module Authenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :current_resource, :resource_signed_in?
  end

  def require_resource!
    redirect_to sign_in_path unless resource_signed_in?
  end

  def require_no_resource!
    redirect_to after_sign_in_path if resource_signed_in?
  end

  def current_resource
    @current_resource ||= resource_class.find_by(id: session[session_key])
  end

  def resource_signed_in?
    current_resource.present?
  end

  def sign_in(resource)
    session[session_key] = resource.id
    @current_resource = nil
  end

  def sign_out
    session.delete(session_key)
    @current_resource = nil
  end

  private

  def resource_class
    raise NotImplementedError, "#{self.class}#resource_class must be implemented"
  end

  def session_key
    raise NotImplementedError, "#{self.class}#session_key must be implemented"
  end

  def sign_in_path
    raise NotImplementedError, "#{self.class}#sign_in_path must be implemented"
  end

  def after_sign_in_path
    raise NotImplementedError, "#{self.class}#after_sign_in_path must be implemented"
  end
end
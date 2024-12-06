module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_admin

    def connect
      self.current_admin = find_verified_admin
    end

    private

    def find_verified_admin
      Admin.find(request.session[:admin_id])
    rescue ActiveRecord::RecordNotFound
      reject_unauthorized_connection
    end
  end
end

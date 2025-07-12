class User::Core < ApplicationRecord

  include Authentication

  has_many :password_resets, class_name: 'User::PasswordReset', foreign_key: 'user_id', dependent: :destroy
  has_many :email_changes, class_name: 'User::EmailChange', foreign_key: 'user_id', dependent: :destroy

  def self.ransackable_associations(_auth_object = nil)
    %w[
      email_changes
      password_resets
    ]
  end

end

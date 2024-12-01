class User::Core < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  has_many :password_resets, class_name: "User::PasswordReset", foreign_key: "user_id", dependent: :destroy
  has_many :email_changes, class_name: "User::EmailChange", foreign_key: "user_id", dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      email
      id
      password_digest
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[
      email_changes
      password_resets
    ]
  end
end

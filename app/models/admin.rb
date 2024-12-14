class Admin < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email id password_digest updated_at]
  end
end

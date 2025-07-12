# frozen_string_literal: true

module Authentication

  extend ActiveSupport::Concern

  included do
    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, on: :create
  end

  class_methods do
    def ransackable_attributes(_auth_object = nil)
      %w[
        created_at
        email
        id
        updated_at
      ]
    end
  end

end

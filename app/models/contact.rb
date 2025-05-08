class Contact < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true
  validates :text, presence: true
  validates :phone_number, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      email
      id
      name
      text
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

end

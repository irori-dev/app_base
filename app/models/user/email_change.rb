class User::EmailChange < ApplicationRecord
  include Tokenizable

  EXPIRED_TIME = 30.minutes

  validates :email, presence: true

  belongs_to :user, class_name: 'User::Core', foreign_key: 'user_id'

  scope :not_changed, -> { where(changed_at: nil) }

  alias change_token token
  alias change_digest digest
  alias change_digest= digest=

  def send_email_changed_email
    EmailChangeMailer.for_user(self).deliver_now
  end


  def change!
    ActiveRecord::Base.transaction do
      user.update!(email:)
      update!(changed_at: Time.current)
    end
  end


end

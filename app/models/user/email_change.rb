class User::EmailChange < ApplicationRecord

  include Tokenizable
  include ExpirableToken

  tokenizable digest_column: :change_digest

  validates :email, presence: true
  validates :change_digest, presence: true, uniqueness: true

  belongs_to :user, class_name: 'User::Core', foreign_key: 'user_id'

  scope :not_changed, -> { where(changed_at: nil) }

  alias change_token token

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

class User::PasswordReset < ApplicationRecord

  include Tokenizable
  include ExpirableToken

  tokenizable digest_column: :reset_digest

  validates :reset_digest, presence: true, uniqueness: true

  belongs_to :user, class_name: 'User::Core', foreign_key: 'user_id'

  scope :not_reset, -> { where(reset_at: nil) }

  alias reset_token token

  def send_password_reset_email
    PasswordResetMailer.for_user(self).deliver_now
  end

  def reset!
    update!(reset_at: Time.current)
  end

end

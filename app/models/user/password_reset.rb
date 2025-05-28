class User::PasswordReset < ApplicationRecord
  include Tokenizable

  EXPIRED_TIME = 30.minutes

  belongs_to :user, class_name: 'User::Core', foreign_key: 'user_id'

  scope :not_reset, -> { where(reset_at: nil) }

  alias reset_token token

  def reset_digest
    digest
  end

  def reset_digest=(value)
    self.digest = value
  end

  def send_password_reset_email
    PasswordResetMailer.for_user(self).deliver_now
  end

  def reset!
    update!(reset_at: Time.current)
  end

  private

  def digest_column
    :reset_digest
  end
end

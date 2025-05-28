class User::PasswordReset < ApplicationRecord

  include Tokenizable

  EXPIRED_TIME = 30.minutes

  validates :reset_digest, presence: true, uniqueness: true

  belongs_to :user, class_name: 'User::Core', foreign_key: 'user_id'

  scope :not_reset, -> { where(reset_at: nil) }
  scope :not_expired, -> { where('created_at > ?', EXPIRED_TIME.ago) }

  alias reset_token token

  def reset_digest
    self[:reset_digest]
  end

  def reset_digest=(value)
    self[:reset_digest] = value
  end

  def send_password_reset_email
    PasswordResetMailer.for_user(self).deliver_now
  end

  def reset!
    update!(reset_at: Time.current)
  end

  private

  def digest_column
    'reset_digest'
  end

end

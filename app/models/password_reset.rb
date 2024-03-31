class PasswordReset < ApplicationRecord
  attr_accessor :reset_token

  EXPIRED_TIME = 30.minutes

  validates :reset_digest, presence: true, uniqueness: true

  belongs_to :password_resettable, polymorphic: true

  scope :not_expired, -> { where('created_at > ?', EXPIRED_TIME.ago) }
  scope :not_reset, -> { where(reset_at: nil) }
  scope :detected_by, lambda { |token|
                        detect(proc {
                                 raise ArgumentError, '期限切れ、もしくは無効なトークンです'
                               }) { |password_reset| password_reset.match?(token) }
                      }

  def initialize(attributes = {})
    super
    create_reset_digest
  end

  def send_password_reset_email
    PasswordResetMailer.for_resettable(self).deliver_now
  end

  def match?(token)
    BCrypt::Password.new(reset_digest).is_password?(token)
  end

  def reset!
    update!(reset_at: Time.current)
  end

  private

  def create_reset_digest
    self.reset_token = PasswordReset.new_token
    self.reset_digest = PasswordReset.digest(reset_token)
  end

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end

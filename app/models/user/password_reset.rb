class User::PasswordReset < ApplicationRecord
  attr_accessor :reset_token

  EXPIRED_TIME = 30.minutes

  validates :reset_digest, presence: true, uniqueness: true

  belongs_to :user, class_name: "User::Core", foreign_key: "user_id"

  scope :not_expired, -> { where("created_at > ?", EXPIRED_TIME.ago) }
  scope :not_reset, -> { where(reset_at: nil) }
  scope :detected_by, lambda { |token|
                        detect(proc {
                                 raise ArgumentError, "\u671F\u9650\u5207\u308C\u3001\u3082\u3057\u304F\u306F\u7121\u52B9\u306A\u30C8\u30FC\u30AF\u30F3\u3067\u3059"
                               }) { |password_reset| password_reset.match?(token) }
                      }

  def initialize(attributes = {})
    super
    create_reset_digest
  end

  def send_password_reset_email
    PasswordResetMailer.for_user(self).deliver_now
  end

  def match?(token)
    BCrypt::Password.new(reset_digest).is_password?(token)
  end

  def reset!
    update!(reset_at: Time.current)
  end

  private

  def create_reset_digest
    self.reset_token = User::PasswordReset.new_token
    self.reset_digest = User::PasswordReset.digest(reset_token)
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

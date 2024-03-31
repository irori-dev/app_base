class EmailChange < ApplicationRecord
  attr_accessor :change_token

  EXPIRED_TIME = 30.minutes

  validates :change_digest, presence: true, uniqueness: true
  validates :email, presence: true

  belongs_to :email_changeable, polymorphic: true

  scope :not_expired, -> { where('created_at > ?', EXPIRED_TIME.ago) }
  scope :not_changed, -> { where(changed_at: nil) }
  scope :detected_by, lambda { |token|
                        detect(proc {
                                 raise ArgumentError, '期限切れ、もしくは無効なトークンです'
                               }) { |email_change| email_change.match?(token) }
                      }

  def initialize(attributes = {})
    super
    create_change_digest
  end

  def send_email_changed_email
    EmailChangeMailer.for_changeable(self).deliver_now
  end

  def match?(token)
    BCrypt::Password.new(change_digest).is_password?(token)
  end

  def change!
    update!(changed_at: Time.current)
  end

  private

  def create_change_digest
    self.change_token = EmailChange.new_token
    self.change_digest = EmailChange.digest(change_token)
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

class User::EmailChange < ApplicationRecord

  attr_accessor :change_token

  EXPIRED_TIME = 30.minutes

  validates :change_digest, presence: true, uniqueness: true
  validates :email, presence: true

  belongs_to :user, class_name: 'User::Core', foreign_key: 'user_id'

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
    EmailChangeMailer.for_user(self).deliver_now
  end

  def match?(token)
    BCrypt::Password.new(change_digest).is_password?(token)
  end

  def change!
    ActiveRecord::Base.transaction do
      user.update!(email:)
      update!(changed_at: Time.current)
    end
  end

  private

  def create_change_digest
    self.change_token = User::EmailChange.new_token
    self.change_digest = User::EmailChange.digest(change_token)
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

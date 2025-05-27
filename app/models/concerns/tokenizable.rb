# frozen_string_literal: true

module Tokenizable
  extend ActiveSupport::Concern

  included do
    attr_accessor :token

    validates :digest, presence: true, uniqueness: true

    scope :not_expired, -> { where('created_at > ?', self::EXPIRED_TIME.ago) }
    scope :detected_by, lambda { |token|
      detect(proc { raise ArgumentError, '期限切れ、もしくは無効なトークンです' }) { |record| record.match?(token) }
    }

    after_initialize :create_digest, if: :new_record?
  end

  def match?(token)
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

  def create_digest
    self.token = self.class.new_token
    self.digest = self.class.digest(token)
  end

  class_methods do
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def digest
    raise NotImplementedError, "#{self.class} must define digest attribute"
  end

  def digest=(value)
    raise NotImplementedError, "#{self.class} must define digest= attribute"
  end
end
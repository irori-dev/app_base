# frozen_string_literal: true

module Tokenizable
  extend ActiveSupport::Concern

  included do
    attr_accessor :token

    validates digest_column, presence: true, uniqueness: true

    scope :not_expired, -> { where('created_at > ?', const_get(:EXPIRED_TIME).ago) }
    scope :detected_by, lambda { |token|
      not_expired.detect(proc { raise ArgumentError, '期限切れ、もしくは無効なトークンです' }) { |record| record.match?(token) }
    }

    after_initialize :create_digest, if: :new_record?
  end

  def match?(token)
    BCrypt::Password.new(digest).is_password?(token)
  end

  def digest
    send(digest_column)
  end

  def digest=(value)
    send("#{digest_column}=", value)
  end

  private

  def create_digest
    self.token = self.class.new_token
    self.digest = self.class.digest(token)
  end

  def digest_column
    raise NotImplementedError, "#{self.class} must define digest_column method"
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
end
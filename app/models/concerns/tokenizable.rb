# frozen_string_literal: true

module Tokenizable
  extend ActiveSupport::Concern

  included do
    attr_accessor :token

    after_initialize :create_digest, if: :new_record?
  end

  class_methods do
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def detected_by(token)
      candidates = not_expired.to_a
      found = candidates.find { |record| record.match?(token) }
      found || (raise ArgumentError, '期限切れ、もしくは無効なトークンです')
    end
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

end
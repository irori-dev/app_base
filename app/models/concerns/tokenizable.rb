# frozen_string_literal: true

module Tokenizable

  extend ActiveSupport::Concern

  included do
    attr_accessor :token

    after_initialize :create_digest, if: :new_record?

    class_attribute :tokenizable_options, default: {}
  end

  class_methods do
    def tokenizable(digest_column: nil, raise_on_invalid: true)
      self.tokenizable_options = {
        digest_column: digest_column,
        raise_on_invalid: raise_on_invalid,
      }
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def detected_by(token, raise_on_invalid: nil)
      raise_on_invalid = tokenizable_options[:raise_on_invalid] if raise_on_invalid.nil?

      candidates = not_expired.to_a
      found = candidates.find { |record| record.match?(token) }

      return found if found
      return nil unless raise_on_invalid

      raise ArgumentError, '期限切れ、もしくは無効なトークンです'
    end
  end

  def match?(token)
    BCrypt::Password.new(digest).is_password?(token)
  rescue BCrypt::Errors::InvalidHash
    false
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
    self.class.tokenizable_options[:digest_column] ||
      raise(NotImplementedError, "#{self.class} must define digest_column or use tokenizable method")
  end

end

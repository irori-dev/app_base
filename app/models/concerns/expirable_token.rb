# frozen_string_literal: true

module ExpirableToken

  extend ActiveSupport::Concern

  EXPIRED_TIME = 30.minutes

  included do
    scope :not_expired, -> { where('created_at > ?', EXPIRED_TIME.ago) }
  end

end

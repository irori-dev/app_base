class User::EmailChange < ApplicationRecord

  include Tokenizable

  EXPIRED_TIME = 30.minutes

  validates :email, presence: true
  validates :change_digest, presence: true, uniqueness: true

  belongs_to :user, class_name: 'User::Core', foreign_key: 'user_id'

  scope :not_changed, -> { where(changed_at: nil) }
  scope :not_expired, -> { where('created_at > ?', EXPIRED_TIME.ago) }

  alias change_token token

  def change_digest
    self[:change_digest]
  end

  def change_digest=(value)
    self[:change_digest] = value
  end

  def send_email_changed_email
    EmailChangeMailer.for_user(self).deliver_now
  end

  def change!
    ActiveRecord::Base.transaction do
      user.update!(email:)
      update!(changed_at: Time.current)
    end
  end

  private

  def digest_column
    'change_digest'
  end

end

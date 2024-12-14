FactoryBot.define do
  factory :user_password_reset, class: User::PasswordReset do
    association :user, factory: :user_core, strategy: :create
    reset_digest { BCrypt::Password.create(SecureRandom.urlsafe_base64, cost: BCrypt::Engine::MIN_COST) }
    reset_at { Time.zone.now }
  end
end

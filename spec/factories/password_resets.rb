FactoryBot.define do
  factory :password_reset do
    association :password_resettable, factory: :user
    password_resettable_type { 'User' }
    reset_digest { BCrypt::Password.create(SecureRandom.urlsafe_base64, cost: BCrypt::Engine::MIN_COST) }
    reset_at { '2020-05-31 15:00:00' }
  end
end

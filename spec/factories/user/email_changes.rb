FactoryBot.define do
  factory :user_email_change, class: User::EmailChange do
    association :user, factory: :user_core, strategy: :create
    sequence(:email) { |n| "change-test#{n}@example.com" }
    change_digest { BCrypt::Password.create(SecureRandom.urlsafe_base64, cost: BCrypt::Engine::MIN_COST) }
    changed_at { Time.zone.now }
  end
end

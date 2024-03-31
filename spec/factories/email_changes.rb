FactoryBot.define do
  factory :email_change do
    association :email_changeable, factory: :user
    email_changeable_type { 'User' }
    sequence(:email) { |n| "change-test#{n}@example.com" }
    change_digest { BCrypt::Password.create(SecureRandom.urlsafe_base64, cost: BCrypt::Engine::MIN_COST) }
    changed_at { '2020-05-31 15:00:00' }
  end
end

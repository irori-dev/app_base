FactoryBot.define do
  factory :user_email_change, class: User::EmailChange do
    association :user, factory: :user_core, strategy: :create
    sequence(:email) { |n| "change-test#{n}@example.com" }
    changed_at { nil }
  end
end

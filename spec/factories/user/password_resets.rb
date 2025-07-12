FactoryBot.define do
  factory :user_password_reset, class: User::PasswordReset do
    association :user, factory: :user_core, strategy: :create
    reset_at { nil }
  end
end

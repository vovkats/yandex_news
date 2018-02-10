FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com"}
    password 'rootroot'
    password_confirmation 'rootroot'
  end
end
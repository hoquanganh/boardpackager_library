FactoryBot.define do
  factory :document do
    association :user
  end

  factory(:user) do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end

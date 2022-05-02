FactoryBot.define do
  factory :list do
    association :user, factory: :user
    title { generate(:title) }
  end
end

FactoryBot.define do
  factory :read do
    association :user, factory: :user
    association :article, factory: :article
  end
end

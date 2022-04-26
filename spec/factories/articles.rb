FactoryBot.define do
  factory :article do
    association :source, factory: :source
    title { generate(:title) }
    body  { "text" }
  end
end
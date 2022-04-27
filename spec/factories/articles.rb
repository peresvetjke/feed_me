FactoryBot.define do
  factory :article do
    association :source, factory: :source
    title { generate(:title) }
    body  { "text" }
    publication_date { Time.now }
  end
end
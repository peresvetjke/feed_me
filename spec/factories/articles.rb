FactoryBot.define do
  factory :article do
    association :source, factory: :source
    title { generate(:title) }
    body  { "text" }
    url   { generate(:url) }
    publication_date { Time.now }
  end
end
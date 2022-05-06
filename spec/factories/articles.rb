FactoryBot.define do
  factory :article do
    association :source, factory: :source
    title { generate(:title) }
    body  { "text" }
    url   { "url" }
    publication_date { Time.now }
  end
end
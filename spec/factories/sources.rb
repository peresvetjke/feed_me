FactoryBot.define do
  factory :source do
    title         { generate(:title) }
    base_url      { "url" }
    articles_path { "/" }
  end
end
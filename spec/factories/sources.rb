FactoryBot.define do
  factory :source do
    title { generate(:title) }
    url   { "url" }
  end
end
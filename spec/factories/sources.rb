FactoryBot.define do
  factory :source do
    title    { generate(:title) }
    base_url { generate(:base_url) }
  end
end
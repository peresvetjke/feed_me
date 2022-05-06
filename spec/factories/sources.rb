FactoryBot.define do
  factory :source do
    title         { generate(:title) }
    articles_path { "/" }
    base_url      { generate(:base_url) }
    title_xpath   { "title_css" }
    body_xpath    { "body_css" }
    publication_date_xpath { "publication_date_css" }
  end
end
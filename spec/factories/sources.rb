FactoryBot.define do
  factory :source do
    title         { generate(:title) }
    articles_path { "/" }
    base_url      { generate(:base_url) }
    article_css   { "article_css" }
    title_css     { "title_css" }
    body_css      { "body_css" }
    publication_date_css { "publication_date_css" }
  end
end
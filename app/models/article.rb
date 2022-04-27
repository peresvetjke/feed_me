class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope ->{ order(publication_date: :desc) }

  field :title, type: String
  field :body, type: String
  field :url, type: String
  field :publication_date, type: DateTime

  belongs_to :source

  validates :title, presence: true
  validates :body, presence: true
end

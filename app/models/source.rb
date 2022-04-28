class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :base_url, type: String
  field :articles_path, type: String
  field :article_css, type: String
  field :article_url_exceptions, type: Array, default: []
  field :title_css, type: String
  field :body_css, type: String
  field :publication_date_css, type: String

  has_many :articles, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :base_url, presence: true
  validates :article_css, presence: true
  validates :title_css, presence: true
  validates :body_css, presence: true
  validates :publication_date_css, presence: true
end

class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :body, type: String

  belongs_to :source

  validates :title, presence: true
  validates :body, presence: true
end

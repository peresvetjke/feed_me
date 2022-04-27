class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :base_url, type: String
  field :articles_path, type: String

  has_many :articles, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :base_url, presence: true
  validates :articles_path, presence: true
end

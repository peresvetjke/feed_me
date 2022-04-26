class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :url, type: String

  has_many :articles, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :url, presence: true
end

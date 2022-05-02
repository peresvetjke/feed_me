class List
  include Turbo::Broadcastable
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String

  belongs_to :user
  has_many :list_sources, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :user }
end
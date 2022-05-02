class List
  include Turbo::Broadcastable
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  
  # after_create  { broadcast_append_to "lists", partial: "lists/list" }
  # after_update  { broadcast_replace_to "lists", partial: "lists/list" }
  # after_destroy { broadcast_remove_to "lists" }

  belongs_to :user
  has_many :list_sources, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :user }
end
class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope ->{ order(publication_date: :desc) }

  field :title, type: String
  field :body, type: String
  field :url, type: String
  field :publication_date, type: DateTime

  belongs_to :source
  has_many :reads, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def self.read_by(user)
    reads = Read.in(user_id: user.id)
    Article.in(id: reads.pluck(:article_id)).to_a
  end

  def mark_read!(user:)
    read = reads.find_or_initialize_by(user: user)
    
    if read.persisted?
      read.destroy! 
    else
      read.save!
    end
  end
end

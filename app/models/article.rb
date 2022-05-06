require 'elasticsearch/model'

class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  default_scope ->{ order(publication_date: :desc) }

  field :title, type: String
  field :body, type: String
  field :url, type: String
  field :publication_date, type: DateTime

  belongs_to :source
  has_many :reads, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :url, presence: true
  validates :publication_date, presence: true

  def self.search_articles(query_params)
    if query_params[:query].present?
      articles = Article.__elasticsearch__.search(query_params[:query]).records
    else
      articles = Article.all
    end

    if query_params[:lists].present?
      list = List.find(BSON::ObjectId.from_string(query_params[:lists].first))
      sources = list.list_sources.map{ |list_source| list_source.source }
      articles = articles.where(:source.in => sources)
    elsif query_params[:sources].present?
      sources = query_params[:sources].map { |id| BSON::ObjectId.from_string(id) }
      articles = articles.where(:source.in => sources)
    end
    articles.to_a
  end

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

  def as_indexed_json(options = {})
    as_json(except: [:id, :_id]) 
  end 
end

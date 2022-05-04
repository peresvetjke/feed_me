require "#{Rails.root}/app/models/article"

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'] || "http://localhost:9200/" 
)

unless Article.__elasticsearch__.index_exists?
  Article.__elasticsearch__.create_index! force: true 
  Article.import 
end
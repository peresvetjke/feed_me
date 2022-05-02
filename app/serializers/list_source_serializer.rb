class ListSourceSerializer
  include JSONAPI::Serializer
  # attributes 

  belongs_to :list
  belongs_to :source
end

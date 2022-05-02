class ListSource
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :list
  belongs_to :source
end

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'associations' do
    it_behaves_like "belongs_to", :source
    it_behaves_like "has_many", { associations: :reads, dependent_destroy: true }
  end


  describe 'validations' do
    it_behaves_like "validates_presence_of", :title
    it_behaves_like "validates_presence_of", :body
  end
end

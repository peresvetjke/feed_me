require 'rails_helper'

RSpec.describe Source, type: :model do
  describe 'associations' do
    it_behaves_like "has_many", { associations: :articles, dependent_destroy: true }

  end

  describe 'validations' do
    it_behaves_like "validates_presence_of", :title
    it_behaves_like "validates_presence_of", :url
    it_behaves_like "validates_uniqueness_of", :title
  end
end
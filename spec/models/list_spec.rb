require 'rails_helper'

RSpec.describe List, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:list_sources).with_dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }    
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:user) }
  end
end

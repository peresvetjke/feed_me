require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:source) }
    it { is_expected.to have_many(:reads).with_dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end
end

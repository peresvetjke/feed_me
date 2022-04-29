require 'rails_helper'

RSpec.describe Read, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:article) }
  end
end

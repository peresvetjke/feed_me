require 'rails_helper'

RSpec.describe SourceList, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to belong_to(:source) }
  end
end

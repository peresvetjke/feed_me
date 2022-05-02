require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:reads).with_dependent(:destroy) }
    it { is_expected.to have_many(:lists).with_dependent(:destroy) }
  end
end

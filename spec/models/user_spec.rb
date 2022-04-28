require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it_behaves_like "has_many", { associations: :reads, dependent_destroy: true }
  end
end

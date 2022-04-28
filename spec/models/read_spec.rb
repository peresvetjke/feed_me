require 'rails_helper'

RSpec.describe Read, type: :model do
  describe 'associations' do
    it_behaves_like "belongs_to", :user
    it_behaves_like "belongs_to", :article
  end
end

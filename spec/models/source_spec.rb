require 'rails_helper'

RSpec.describe Source, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:articles).with_dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }   
    it { is_expected.to validate_presence_of(:base_url) }   
    it { is_expected.to validate_presence_of(:article_css) }   
    it { is_expected.to validate_presence_of(:title_css) }   
    it { is_expected.to validate_presence_of(:body_css) }   
    it { is_expected.to validate_presence_of(:publication_date_css) }    
    it { is_expected.to validate_uniqueness_of(:title) }
  end
end

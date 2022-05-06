require 'rails_helper'

RSpec.describe Source, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:articles).with_dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }   
    it { is_expected.to validate_presence_of(:base_url) }   
    it { is_expected.to validate_presence_of(:title_xpath) }   
    it { is_expected.to validate_presence_of(:body_xpath) }   
    it { is_expected.to validate_presence_of(:publication_date_xpath) }    
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe "#assigned_list" do
    let!(:user)   { create(:user) }
    let!(:list)   { create(:list, user: user) }
    let!(:source) { create(:source) }

    context "with assignment" do
      let!(:list_source) { create(:list_source, source: source, list: list) }

      it "returns list" do
        expect(source.assigned_list(user)).to eq list
      end
    end
    
    context "without assignment" do
      it "returns nil" do
        expect(source.assigned_list(user)).to be_nil
      end
    end
  end

  describe "#assign_to_list" do
    let!(:user)   { create(:user) }
    let!(:list)   { create(:list, user: user) }
    let!(:source) { create(:source) }

    subject { source.assign_to_list!(list) }

    context "no current assignment" do
      it "creates new list_sources record in db" do
        expect { subject }.to change(ListSource, :count).by(1)
      end

      it "assigns source to list" do
        subject
        expect(source.assigned_list(user)).to eq list
      end
    end

    context "existing assignment" do
      let!(:list_source) { create(:list_source, list: list, source: source) }

      it "does not change list_sources records count in db" do
        expect { subject }.not_to change(ListSource, :count)
      end

      it "assigns source to list" do
        subject
        expect(source.assigned_list(user)).to eq list
      end
    end
  end

  describe "#clear_assignment" do
    let!(:user)       { create(:user) }
    let!(:list)       { create(:list, user: user) }
    let!(:source)     { create(:source) }
    
    subject { source.clear_assignment!(user) }

    context "no current assignment" do
      it "changes assignment to nil" do
        subject
        expect(source.assigned_list(user)).to be_nil
      end
      
      it "does not change list_sources records count in db" do
        expect { subject }.not_to change(ListSource, :count)
      end
    end

    context "existing assignment" do
      let!(:list_source) { create(:list_source, list: list, source: source) }

      it "changes assignment to nil" do
        subject
        expect(source.assigned_list(user)).to be_nil
      end

      it "deletes list_sources record from db" do
        expect { subject }.to change(ListSource, :count).by(-1)
      end
    end
  end
end

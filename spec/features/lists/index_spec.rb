require "rails_helper"

feature 'User can index lists', js: true do

  let!(:user)   { create(:user) }
  let!(:lists)  { create_list(:list, 5, user: user) }

  background { sign_in(user) }

  it "displays lists list" do
    visit lists_path
    lists.each do |list|
      expect(page).to have_content(list.title)
    end
  end
end
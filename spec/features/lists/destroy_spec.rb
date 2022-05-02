require "rails_helper"

feature 'User can delete lists', js: true do

  let!(:user) { create(:user) }
  let!(:list) { create(:list, user: user) }

  background { sign_in(user) }

  scenario "deletes a list" do
    visit lists_path
    expect(page).to have_content list.title
    accept_confirm { click_link "Delete" }
    expect(page).to have_no_content list.title
  end

end
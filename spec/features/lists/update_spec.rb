require "rails_helper"

feature 'User can update list', js: true do

  let!(:user) { create(:user) }
  let!(:list) { create(:list, user: user) }

  background { sign_in(user) }

  context "with invalid params" do
    scenario "displays errors" do
      visit lists_path
      within "##{dom_id(list)}" do
        click_link "Edit"
        sleep(0.5)
        fill_in "list_title", with: ""
        click_button "Save"
      end
      expect(page).to have_content "can't be blank"
    end
  end

  context "with valid params" do
    scenario "creates new category" do
      visit lists_path
      within "##{dom_id(list)}" do
        click_link "Edit"
        sleep(0.5)
        fill_in "list_title", with: "New title"
        click_button "Save"
      end
      expect(page).to have_content "New title"
      expect(page.find("##{dom_id(list)}")).to have_no_button "Save"
    end
  end

end
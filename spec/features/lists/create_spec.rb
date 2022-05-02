require "rails_helper"

feature 'User can create new list', js: true do
  
  background { sign_in(create(:user)) }

  context "with invalid params" do
    scenario "displays errors" do
      visit lists_path
      fill_in "list_title", with: ""
      click_button "Save"
      expect(page).to have_content I18n.t("errors.messages.blank")
    end
  end

  context "with valid params" do
    scenario "creates new list" do
      visit lists_path
      fill_in "list_title", with: "New title"
      click_button "Save"
      expect(page).to have_content "New title"
    end
  end
end
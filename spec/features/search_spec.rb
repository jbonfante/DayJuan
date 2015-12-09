require 'spec_helper.rb'

feature "Looking up Sections", js: true do
  before do
    Section.create!(name: 'Baked Potato w/ Cheese')
    Section.create!(name: 'Garlic Mashed Potatoes')
    Section.create!(name: 'Potatoes Au Gratin')
    Section.create!(name: 'Baked Brussel Sprouts')
  end
  scenario "finding Sections" do
    visit '/'
    fill_in "keywords", with: "baked"
    click_on "Search"

    expect(page).to have_content("Baked Potato")
    expect(page).to have_content("Baked Brussel Sprouts")
  end
end
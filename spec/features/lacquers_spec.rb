require 'rails_helper'
include IntegrationSpecHelper

describe "adding, editing, and deleting lacquers" do
  it "allows a user to add a new lacquer with valid inputs", js: true do
    @brand = create(:brand, name: "OPI")
    @color = create(:color, name: "red")
    @finish = create(:finish, description: "creme")
    login_with_oauth
    visit('/users/1')
    
    select "OPI", :from => "brand-selection"
    select "other", :from => "user_lacquer_lacquer_id"
    click_button("Select Colors")
    page.check('red')
    click_button("Select Finishes")
    page.check('creme')
    
    page.fill_in 'Name', :with => 'New Lacquer'
    
    expect{
      click_button("Create Lacquer")
      }.to change{Lacquer.count}.from(0).to(1)
    
    #binding.pry
    expect(Lacquer.first.brand).to eq(@brand)
    expect(Lacquer.first.user_who_added_me).to eq(User.first)
    expect(Lacquer.user_added).to include(Lacquer.first)
    expect(Lacquer.first.color_tags).to include("red")
    expect(Lacquer.first.finish_tags).to include("creme")
  end

  it "does not allow a user to add a new lacquer without inputs", js: true do
    @brand = create(:brand, name: "OPI")
    login_with_oauth
    visit('/users/1')

    select "OPI", :from => "brand-selection"
    select "other", :from => "user_lacquer_lacquer_id"

    expect{
      click_button("Create Lacquer")
      }.not_to change{Lacquer.count}
  end
end

describe "editing lacquers" do
  it "allows the user who added a lacquer to edit its name", js: true do
    @brand = create(:brand, name: "OPI")
    @color = create(:color, name: "red")
    @finish = create(:finish, description: "creme")
    login_with_oauth
    visit('/users/1')
    
    select "OPI", :from => "brand-selection"
    select "other", :from => "user_lacquer_lacquer_id"

    page.fill_in 'Name', :with => 'New Lacquer'
    
    expect{
      click_button("Create Lacquer")
      }.to change{Lacquer.count}.from(0).to(1)
    
    visit('/lacquers/1/edit')

    expect(page).to have_field("Name")
    page.fill_in 'Name', :with => 'My Lacquer'
    
    binding.pry
    click_button("Update Lacquer")
    binding.pry
    expect(Lacquer.first.name).to eq('My Lacquer')
    
  end

  it "allows a user who has a lacquer they did not add to edit colors and finishes but not name", js: true do
    @brand = create(:brand, name: "OPI")
    @color = create(:color, name: "red")
    @finish = create(:finish, description: "creme")
    @lacquer = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil")
    @lucys_lacquer = create(:user_lacquer, user_id: 1, lacquer_id: 1)
    login_with_oauth

    visit('/lacquers/1/edit')

    expect(page).to_not have_field("Name")

    expect(Lacquer.first.color_tags).to be_empty
    expect(Lacquer.first.finish_tags).to be_empty

    page.check('red')
    page.check('creme')

    click_button("Update Lacquer")

    expect(Lacquer.first.color_tags).to include('red')
    expect(Lacquer.first.finish_tags).to include('creme')

    visit('/lacquers/1')

    expect(page).to have_content('Color Tags')
    expect(page).to have_content('#red')
    expect(page).to have_content('Finish Tags')
    expect(page).to have_content('#creme')
  end

  it "allows a user who has a lacquer they did not add to upload a swatch and delete a swatch they added", js: true do
    @brand = create(:brand, name: "OPI")
    @color = create(:color, name: "red")
    @finish = create(:finish, description: "creme")
    @lacquer = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil")
    @lucys_lacquer = create(:user_lacquer, user_id: 1, lacquer_id: 1)

    login_with_oauth

    visit('/lacquers/1/edit')

    expect(page).to_not have_field("Name")

    expect(Lacquer.first.swatches.count).to eq(0)

    attach_file "lacquer_swatches_attributes_0_image", File.join(Rails.root, '/spec/support/generic-polish.png')

    click_button("Update Lacquer")
   
    expect(page).to have_link("delete this swatch")

    expect(Lacquer.first.swatches.count).to eq(1)

    binding.pry

    click_link("delete this swatch")

    expect(Lacquer.first.swatches.count).to eq(0)

    visit('/users/1')

    click_button("Create Swatch")

    expect(Lacquer.first.swatches.count).to eq(0)

    @swatch_not_added_by_lucy = create(:swatch)

    expect(@lucys_lacquer.swatch_image).to eq(@lacquer.swatches.first.image.url(:thumb))

    visit('/users/1')

    Swatch.last.destroy

    visit('/users/1')

    attach_file "swatch_image", File.join(Rails.root, '/spec/support/generic-polish.png')

    binding.pry

    click_button("Create Swatch")

    expect(Lacquer.first.swatches.count).to eq(1)

  end

  it "allows a user to delete a lacquer from her collection without deleting the lacquer itself", js: true do
    @brand = create(:brand, name: "OPI")
    @lacquer = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil", default_picture: 'app/assets/images/file-not-found.png')
    @lucys_lacquer = create(:user_lacquer, user_id: 1, lacquer_id: 1)
    login_with_oauth
    visit('/users/1')
    expect(page).to have_link('x')
    click_link('x')
    binding.pry
    expect(UserLacquer.count).to eq(0)
    expect(Lacquer.count).to eq(1)
  end

  it "allows a user to add a lacquer that was already in the database", js: true do
    @brand = create(:brand, name: "OPI")
    @lacquer = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil", default_picture: 'app/assets/images/generic-polish.png')

    login_with_oauth
    visit('/users/1')

    select "OPI", :from => "brand-selection"
    select "The Thrill of Brazil", :from => "user_lacquer_lacquer_id"
    click_button("add this polish")
    
    expect(User.first.lacquers).to include(@lacquer)
  end

end


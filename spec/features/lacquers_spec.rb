require 'rails_helper'

describe "adding lacquers" do
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
  #   @brand = create(:brand, name: "OPI")
  #   login_with_oauth
  #   visit('/users/1')
    
  #   select "OPI", :from => "brand-selection"
  #   select "other", :from => "user_lacquer_lacquer_id"

  #   page.fill_in 'Name', :with => 'New Lacquer'
    
  #   expect{
  #     click_button("Create Lacquer")
  #     }.to change{Lacquer.count}.from(0).to(1)
    
    
  # end

  # it "does not allow a user to add a new lacquer without inputs", js: true do
  #   @brand = create(:brand, name: "OPI")
  #   login_with_oauth
  #   visit('/users/1')

  #   select "OPI", :from => "brand-selection"
  #   select "other", :from => "user_lacquer_lacquer_id"

  #   expect{
  #     click_button("Create Lacquer")
  #     }.not_to change{Lacquer.count}
  end
end


require 'rails_helper'
# context 'when visiting the home page' do
  
#   context 'when logged out' do
#     visit(root_path)
#     it { is_expected.to respond_with 200 }
#   end

# end

context 'when visiting the home page' do
  before do
    visit(root_path)
  end

  it 'responds with 200' do
    #save_and_open_page
    expect(page.status_code).to be(200)
  end
end
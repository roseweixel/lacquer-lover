include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :swatch do
    lacquer_id 1
    image { fixture_file_upload(Rails.root.join('spec', 'support', 'generic-polish.png'), 'image/png') }
  end

end

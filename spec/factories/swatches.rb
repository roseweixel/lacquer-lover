# == Schema Information
#
# Table name: swatches
#
#  id                 :integer          not null, primary key
#  lacquer_id         :integer
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :swatch do
    lacquer_id 1
    image { fixture_file_upload(Rails.root.join('spec', 'support', 'generic-polish.png'), 'image/png') }
  end

end

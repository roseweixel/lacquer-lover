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

require 'rails_helper'

# RSpec.describe Swatch, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

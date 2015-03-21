# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  lacquer_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Favorite, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

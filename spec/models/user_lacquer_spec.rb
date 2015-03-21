# == Schema Information
#
# Table name: user_lacquers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  lacquer_id :integer
#  created_at :datetime
#  updated_at :datetime
#  loanable   :boolean          default(FALSE)
#  on_loan    :boolean          default(FALSE)
#

require 'rails_helper'

# RSpec.describe UserLacquer, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

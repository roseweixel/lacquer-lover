# == Schema Information
#
# Table name: lacquer_words
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  lacquer_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe LacquerWord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: user_lacquer_colors
#
#  id              :integer          not null, primary key
#  user_lacquer_id :integer
#  color_id        :integer
#

class UserLacquerColor < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :color
end

# == Schema Information
#
# Table name: user_lacquer_finishes
#
#  id              :integer          not null, primary key
#  user_lacquer_id :integer
#  finish_id       :integer
#

class UserLacquerFinish < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :finish
end

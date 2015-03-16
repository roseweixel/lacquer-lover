# == Schema Information
#
# Table name: finishes
#
#  id          :integer          not null, primary key
#  description :string(255)
#

class Finish < ActiveRecord::Base
  has_many :user_lacquer_finishes
  has_many :user_lacquers, through: :user_lacquer_finishes
  has_many :lacquers, through: :user_lacquers

  validates_presence_of :description
end

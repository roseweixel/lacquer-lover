class Review < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :user

  validates :rating, :inclusion => {:in => 1..5, :message => "must be between 1 and 5."}
  validates :comments, :presence => true
end

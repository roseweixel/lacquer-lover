class Lacquer < ActiveRecord::Base
  belongs_to :brand
  has_many :lacquer_colors
  has_many :colors, through: :lacquer_colors
  has_many :lacquer_finishes
  has_many :finishes, through: :lacquer_finishes
  has_many :user_lacquers
  has_many :users, through: :user_lacquers

  def color_string
    string_array = []
    colors.each do |color|
      string_array << color.name
    end
    string_array.join(", ")
  end

  def finish_string
    string_array = []
    finishes.each do |finish|
      string_array << finish.description
    end
    string_array.join(", ")
  end
end

class Lacquer < ActiveRecord::Base
  belongs_to :brand
  has_many :user_lacquers, dependent: :destroy
  #has_many :user_lacquer_colors, through: :user_lacquers
  #has_many :user_lacquer_finishes, through: :user_lacquers
  has_many :users, through: :user_lacquers
  has_many :swatches

  validates :name, :brand, presence: true, :on => :create
  validates_length_of :name, :minimum => 1
  validates :name, uniqueness: true

  # accepts_nested_attributes_for :colors
  # accepts_nested_attributes_for :finishes
  accepts_nested_attributes_for :user_lacquers
  accepts_nested_attributes_for :swatches, :reject_if => proc { |attributes| attributes['image'].blank? }


  def color_tags
    colors = []
    @user_lacquers = UserLacquer.where(:lacquer_id => self.id)
    @user_lacquers.each do |user_lacquer|
      user_lacquer.colors.each do |color|
        colors << color.name
      end
    end
    colors
  end

  
  def formatted_name
    shortened = name

    # for Butter lacquers, since many of them end in 'Nail Lacquer'
    if name.end_with?('Nail Lacquer')
      shortened = name.gsub('Nail Lacquer', '')
    end

    if shortened.length > 22
      shortened = "#{shortened.slice(0..21)}..."
    end
    
    shortened
  end

  def finish_tags
    finishes = []
    @user_lacquers = UserLacquer.where(:lacquer_id => self.id)
    @user_lacquers.each do |user_lacquer|
      user_lacquer.finishes.each do |finish|
        finishes << finish.description
      end
    end
    finishes
  end

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

  def self.user_added
    Lacquer.where.not(user_added_by_id: nil)
  end

  def user_who_added_me
    User.where(id: user_added_by_id).first
  end
end

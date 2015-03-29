# == Schema Information
#
# Table name: lacquers
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  brand_id         :integer
#  user_added_by_id :integer
#  default_picture  :string(255)
#  item_url         :string(255)
#

class Lacquer < ActiveRecord::Base
  belongs_to :brand
  has_many :user_lacquers, dependent: :destroy
  has_many :colors, through: :user_lacquers
  has_many :finishes, through: :user_lacquers
  has_many :users, through: :user_lacquers
  has_many :swatches
  has_many :favorites

  has_many :lacquer_words, dependent: :destroy
  has_many :words, through: :lacquer_words

  has_attached_file :stored_image
  validates_attachment_content_type :stored_image, :content_type => /\Aimage\/.*\Z/

  validates :name, :brand, presence: true, :on => :create
  validates_length_of :name, :minimum => 1
  validates_uniqueness_of :name, scope: :brand

  accepts_nested_attributes_for :user_lacquers
  accepts_nested_attributes_for :swatches, :reject_if => proc { |attributes| attributes['image'].blank? }

  after_save :create_words

  def create_words
    words_in_name = name.split(" ")

    words_in_name.each do |word|
      new_word = Word.find_or_create_by(text: word.downcase)
      LacquerWord.create(lacquer_id: self.id, word_id: new_word.id)
    end
  end

  # Potentially use this kind of method when generating Words and LacquerWords (to count "car" and "pool" as words as well as or instead of "car-pool")
  def name_with_no_non_word_chars
    name.gsub(/\W/, " ")
  end

  # def self.fuzzy_find_by_name(search_term)
  #   where( "lower(name) REGEXP ?", '\b' + search_term + '\b' )
  # end

  def self.lacquers_matching_all_words(search_term)
    search_words = search_term.split(" ")
    search_word_ids = Word.where(text: search_words).pluck(:id)
    lacquer_ids = LacquerWord.where(word_id: search_word_ids).pluck(:lacquer_id)

    Lacquer.where(id: lacquer_ids.select{|id| lacquer_ids.count(id) == search_word_ids.count})
  end

  def self.lacquers_matching_most_words(search_term)
    search_words = search_term.split(" ")
    search_word_ids = Word.where(text: search_words).pluck(:id)
    lacquers_matching_most_words = []
    max = search_word_ids.count - 1
    while max > 0 && lacquers_matching_most_words.empty?
      lacquers_matching_most_words = Lacquer.where(id: lacquer_ids.select{|id| lacquer_ids.count(id) == max})
      max -= 1
    end

    lacquers_matching_most_words
  end

  def self.closest_lacquers(search_term)
    search_words = search_term.split(" ")
    closest_lacquers = []
    search_words.each do |search_word|
      binding.pry
      closest_lacquers << Word.find_closest_lacquers(search_word).uniq
    end

    closest_lacquers.uniq.flatten
  end

  def self.fuzzy_find_by_name(search_term)
    search_words = search_term.split(" ")
    search_word_ids = Word.where(text: search_words).pluck(:id)
    lacquer_ids = LacquerWord.where(word_id: search_word_ids).pluck(:lacquer_id)

    lacquers_matching_all_words = Lacquer.where(id: lacquer_ids.select{|id| lacquer_ids.count(id) == search_word_ids.count})

    if lacquers_matching_all_words.empty?
      lacquers_matching_most_words = []
      max = search_word_ids.count - 1
      while max > 0 && lacquers_matching_most_words.empty?
        lacquers_matching_most_words = Lacquer.where(id: lacquer_ids.select{|id| lacquer_ids.count(id) == max})
        max -= 1
      end

      if lacquers_matching_most_words.any?
        return lacquers_matching_most_words
      else
        closest_lacquers = []
        search_words.each do |search_word|
          closest_lacquers << Word.find_closest_lacquers(search_word)
        end
        return closest_lacquers.flatten
      end
    end

    lacquers_matching_all_words
  end

  def levenshtein_distance(string)
    string.downcase!
    text = name.downcase
    m = string.length
    n = text.length
    return m if n == 0
    return n if m == 0
    d = Array.new(m+1) {Array.new(n+1)}

    (0..m).each {|i| d[i][0] = i}
    (0..n).each {|j| d[0][j] = j}
    (1..n).each do |j|
      (1..m).each do |i|
        d[i][j] = if string[i-1] == text[j-1]  # adjust index into string
                    d[i-1][j-1]       # no operation required
                  else
                    [ d[i-1][j]+1,    # deletion
                      d[i][j-1]+1,    # insertion
                      d[i-1][j-1]+1,  # substitution
                    ].min
                  end
      end
    end
    d[m][n]
  end

  def self.find_closest(string)
    results = []
    closest_distance = 3
    Lacquer.all.each do |lacquer|
      distance = lacquer.levenshtein_distance(string)
      if distance <= closest_distance
        results << lacquer
      end
    end
    results
  end

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

    if shortened.length > 21
      shortened = "#{shortened.slice(0..20)}..."
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

  def favorited_by?(user)
    Favorite.find_by(lacquer_id: self.id, user_id: user.id)
  end
end

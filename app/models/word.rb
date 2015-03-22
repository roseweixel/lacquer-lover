# == Schema Information
#
# Table name: words
#
#  id         :integer          not null, primary key
#  text       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Word < ActiveRecord::Base
  has_many :lacquer_words
  has_many :lacquers, through: :lacquer_words

  validates :text, presence: true, uniqueness: true

  def text=(text)
    write_attribute(:text, text.downcase.strip)
  end

  def levenshtein_distance(string)
    string.downcase!
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
    # TODO
  end
end

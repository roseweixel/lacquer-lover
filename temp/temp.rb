class ButterLondon
  
  ALL_URLS = ["http://www.butterlondon.com/Lacquers/", "http://www.butterlondon.com/Lacquers/?range=49%2C96%2C123", "http://www.butterlondon.com/Lacquers/?range=97%2C123%2C123"]
  attr_accessor :polish_urls, :polish_pics, :polish_names

  def initialize
    self.item_urls
    self.images
    self.names
  end

  def item_urls
    @polish_urls = []
    ALL_URLS.each do |page|
      nokogiri_doc = Nokogiri::HTML(open(page))
      polish_url = nokogiri_doc.css('a.mini_category_cell_img')
      polish_url.each do |item|
        url = item.attributes["href"].value
        @polish_urls << url
      end
    end
    @polish_urls
  end

  def images
    @polish_pics = []
    ALL_URLS.each do |page|
      nokogiri_doc = Nokogiri::HTML(open(page))
      image_url = nokogiri_doc.css('div.mini_category_cell img')
      image_url.each do |item|
        polish_pic = item.attributes["src"].value
        @polish_pics << polish_pic
      end
    end
    @polish_pics
  end

  def names
    @polish_names = []
    ALL_URLS.each do |page|
      nokogiri_doc = Nokogiri::HTML(open(page))
      polish_name = nokogiri_doc.css('div.mini_cell_title h5')
      polish_name.each do |item|
        unformatted_name = item.text
        formatted_name_array = []
        unformatted_name_array = unformatted_name.split(" ")
        unformatted_name_array.each do |word|
          formatted_name_array << word.capitalize
        end
        butter_name = formatted_name_array.join(" ")
        @polish_names << butter_name
      end
    end
    @polish_names
  end

end
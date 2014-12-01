class butterLondon
  
  ALL_URLS = ["http://www.butterlondon.com/Lacquers/", "http://www.butterlondon.com/Lacquers/?range=49%2C96%2C123", "http://www.butterlondon.com/Lacquers/?range=97%2C123%2C123"]
  attr_accessor :polish_urls, :polish_pics, :polish_names

  def initialize
    @polish_urls = []
    @polish_pics = []
    @polish_names = []
    self.item_url
    self.image
    self.name
  end

  def item_url
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

  def image
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

  def name
    ALL_URLS.each do |page|
      nokogiri_doc = Nokogiri::HTML(open(page))
      polish_name = nokogiri_doc.css('div.mini_cell_title h5')
      polish_name.each do |item|
        butter_name = item.text
        @polish_names << butter_name
      end
    end
    @polish_names
  end

end
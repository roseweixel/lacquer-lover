class butterLondon
  URL = "http://www.butterlondon.com/Lacquers/"
  attr_accessor :url, :nokogiri_doc, :nail_urls

  def initialize
    @url = URL
    @nokogiri_doc = Nokogiri::HTML(open(url))
    @polish_urls = []
    @polish_pics = []
    @polish_names = []
  end

  def item_url
    item_url = nokogiri_doc.css('a.mini_category_cell_img')
    item_url.each do |item|
      url = item.attributes["href"].value
      @polish_urls << url
      puts "#{url}"
    end
  end

  def image
    image_url = nokogiri_doc.css('div.mini_category_cell img')
    image_url.each do |item|
      polish_pic = item.attributes["src"].value
      @polish_pics << polish_pic
      puts "#{polish_pic}"
    end
  end

  def name
    polish_name = nokogiri_doc.css('div.mini_cell_title h5')
    polish_name.each do |item|
      butter_name = item.text
      @polish_names << butter_name
      puts "#{butter_name}"
    end
  end

end
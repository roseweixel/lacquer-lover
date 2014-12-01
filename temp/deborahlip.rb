class DeborahLippman
  
  URL = "http://www.deborahlippmann.com/nail-color/all"
  attr_accessor :nokogiri_doc, :polish_urls, :polish_pics, :polish_names

  def initialize
    @nokogiri_doc = Nokogiri::HTML(open(URL))
    @polish_urls = []
    @polish_pics = []
    @polish_names = []
    self.item_url
    self.image
    self.name
  end

  def item_url
    polish_url = nokogiri_doc.css('div.item-content a')
    polish_url.each do |item|
      url = item.attributes["href"].value
      @polish_urls << url
    end
    @polish_urls
  end

  def image
    image_url = nokogiri_doc.css('div.popup-product-details div.popup-details-content div.left-section img.lazy-popup')
    image_url.each do |item|
      polish_pic = item.attributes["data-original"].value
      @polish_pics << polish_pic
    end
    @polish_pics
  end

  def name
    polish_name = nokogiri_doc.css('div.item-content a')
    polish_name.each do |item|
      deb_name = item.attributes["title"].value
      @polish_names << deb_name
    end
    @polish_names
  end

end
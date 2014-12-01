class Opi
  
  ALL_URLS = ["http://opi.com/color/nail-lacquers/classics", "http://opi.com/color/nail-lacquers/soft-shades", "http://opi.com/color/nail-lacquers/brights", "http://opi.com/color/nail-lacquers/designer-series"]
  COLLECTIONS_URL = "http://opi.com/color/collections/all"
  attr_accessor :polish_urls, :polish_pics, :polish_names

  def initialize
    @polish_urls = []
    @polish_pics = []
    @polish_names = []
    self.collection_urls
    self.item_url
    self.image
    self.name
  end

  def collection_urls
    nokogiri_doc = Nokogiri::HTML(open(COLLECTIONS_URL))
    url = nokogiri_doc.css('section.caption-container div.caption-holder div.caption-pad a')
    url.each do |item|
      collection = item.attributes["href"].value
      ALL_URLS << collection
    end
    ALL_URLS
  end

  def item_url
    ALL_URLS.each do |page|
      nokogiri_doc = Nokogiri::HTML(open(page))
      polish_url = nokogiri_doc.css('div.product-container div.product-description .product-name a')
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
      image_url = nokogiri_doc.css('div.product-container div.product-shot img')
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
      polish_name = nokogiri_doc.css('div.product-container div.product-description .product-name a')
      polish_name.each do |item|
        opi_name = item.text
        @polish_names << opi_name
      end
    end
    @polish_names
  end

end
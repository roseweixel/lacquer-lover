# class Opi
  
#   ALL_URLS = ["http://opi.com/color/nail-lacquers/classics", "http://opi.com/color/nail-lacquers/soft-shades", "http://opi.com/color/nail-lacquers/brights", "http://opi.com/color/nail-lacquers/designer-series"]
#   COLLECTIONS_URL = "http://opi.com/color/collections/all"
#   attr_accessor :polish_urls, :polish_pics, :polish_names

#   def initialize
#     self.collection_urls
#     self.item_urls
#     self.images
#     self.names
#   end

#   def collection_urls
#     nokogiri_doc = Nokogiri::HTML(open(COLLECTIONS_URL))
#     url = nokogiri_doc.css('section.caption-container div.caption-holder div.caption-pad a')
#     url.each do |item|
#       collection = item.attributes["href"].value
#       ALL_URLS << collection
#     end
#     ALL_URLS
#   end

#   def item_urls
#     @polish_urls = []
#     ALL_URLS.each do |page|
#       nokogiri_doc = Nokogiri::HTML(open(page))
#       polish_url = nokogiri_doc.css('div.product-container div.product-description .product-name a')
#       polish_url.each do |item|
#         url = item.attributes["href"].value
#         @polish_urls << url
#       end
#     end
#     @polish_urls
#   end

#   def images
#     @polish_pics = []
#     ALL_URLS.each do |page|
#       nokogiri_doc = Nokogiri::HTML(open(page))
#       image_url = nokogiri_doc.css('div.product-container div.product-shot img')
#       image_url.each do |item|
#         polish_pic = item.attributes["src"].value
#         @polish_pics << polish_pic
#       end
#     end
#     @polish_pics
#   end

#   def names
#     @polish_names = []
#     ALL_URLS.each do |page|
#       nokogiri_doc = Nokogiri::HTML(open(page))
#       polish_name = nokogiri_doc.css('div.product-container div.product-description .product-name a')
#       polish_name.each do |item|
#         unformatted_name = item.text
#         formatted_name_array = []
#         unformatted_name_array = unformatted_name.split(" ")
#         unformatted_name_array.each do |word|
#           formatted_name_array << word.capitalize
#         end
#         opi_name = formatted_name_array.join(" ")
#         @polish_names << opi_name
#       end
#     end
#     @polish_names
#   end

# end
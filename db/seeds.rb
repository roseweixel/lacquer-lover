class DeborahLippmann
  
  URL = "http://www.deborahlippmann.com/nail-color/all"
  attr_accessor :nokogiri_doc, :polish_urls, :polish_pics, :polish_names

  def initialize
    @nokogiri_doc = Nokogiri::HTML(open(URL))
    self.item_urls
    self.images
    self.names
  end

  def item_urls
    @polish_urls = []
    polish_url = nokogiri_doc.css('div.item-content a')
    polish_url.each do |item|
      url = item.attributes["href"].value
      @polish_urls << url
    end
    @polish_urls
  end

  def images
    @polish_pics = []
    image_url = nokogiri_doc.css('div.popup-product-details div.popup-details-content div.left-section img.lazy-popup')
    image_url.each do |item|
      polish_pic = item.attributes["data-original"].value
      @polish_pics << polish_pic
    end
    @polish_pics
  end

  def names
    @polish_names = []
    polish_name = nokogiri_doc.css('div.item-content a')
    polish_name.each do |item|
      unformatted_name = item.attributes["title"].value
      formatted_name_array = []
      unformatted_name_array = unformatted_name.split(" ")
      unformatted_name_array.each do |word|
        formatted_name_array << word.capitalize
      end
      deb_name = formatted_name_array.join(" ")
      @polish_names << deb_name
    end
    @polish_names
  end

end

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
        @polish_pics << ("http://www.butterlondon.com" + "#{polish_pic}")
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
        @polish_names << butter_name.sub(" Nail Lacquer", "")
      end
    end
    @polish_names
  end

end

class Opi
  
  ALL_URLS = ["http://opi.com/color/nail-lacquers/classics", "http://opi.com/color/nail-lacquers/soft-shades", "http://opi.com/color/nail-lacquers/brights", "http://opi.com/color/nail-lacquers/designer-series"]
  COLLECTIONS_URL = "http://opi.com/color/collections/all"
  attr_accessor :polish_urls, :polish_pics, :polish_names

  def initialize
    self.collection_urls
    self.item_urls
    self.images
    self.names
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

  def item_urls
    @polish_urls = []
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

  def images
    @polish_pics = []
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

  def names
    @polish_names = []
    ALL_URLS.each do |page|
      nokogiri_doc = Nokogiri::HTML(open(page))
      polish_name = nokogiri_doc.css('div.product-container div.product-description .product-name a')
      polish_name.each do |item|
        unformatted_name = item.text
        formatted_name_array = []
        unformatted_name_array = unformatted_name.split(" ")
        unformatted_name_array.each do |word|
          formatted_name_array << word.capitalize
        end
        opi_name = formatted_name_array.join(" ")
        @polish_names << opi_name
      end
    end
    @polish_names
  end

end

class Essie
  
  URL = "http://www.essie.com/Colors.aspx"
  attr_accessor :nokogiri_doc, :polish_urls, :polish_pics, :polish_names

  def initialize
    @nokogiri_doc = Nokogiri::HTML(open(URL))
    self.item_urls
    self.names
    self.images
  end

  def item_urls
    @polish_urls = []
    @polish_pics = []
    @polish_colors = []
    polish_url = nokogiri_doc.css('div.product-wrapper a.bottle')
    polish_url.each do |item|
      url = item.attributes["href"].value
      single_polish_url = ("http://www.essie.com" + "#{url}")
      polish_color = (/(?<=\/Colors\/)\w+/.match(url)).to_s
      no_aspx_url = (/.*(?=.aspx)/.match(url)).to_s
      color_name = (/(?<=\/Colors\/#{polish_color}\/).*/.match(no_aspx_url)).to_s

      if color_name.include?("-")
        color_name = color_name.gsub("-","_")
      end

      image_url = ("http://www.essie.com/~/media/Images/Essie/Global/Home" + "#{no_aspx_url}" + "/" + "#{color_name}" + ".png")

      @polish_urls << single_polish_url
      @polish_colors << polish_color.to_s
      @polish_pics << image_url
    end
    @polish_urls
  end

  def images
    @polish_pics
  end

  def names
    @polish_names = []
    polish_name = nokogiri_doc.css('div.product-wrapper a.bottle')
    polish_name.each do |item|
      unformatted_name = item.text
      formatted_name_array = []
      unformatted_name_array = unformatted_name.split(" ")
      unformatted_name_array.each do |word|
        formatted_name_array << word.capitalize
      end
      essie_name = formatted_name_array.join(" ")
      @polish_names << essie_name
    end
    @polish_names
  end

end

class Zoya
  
  URL = "http://www.zoya.com/content/category/Zoya_Nail_Polish.html"
  attr_accessor :nokogiri_doc, :item_urls, :images, :names

  def initialize
    @nokogiri_doc = Nokogiri::HTML(open(URL))
    scrape
  end

  def scrape
    polish_divs = nokogiri_doc.css("div.item")
    self.item_urls, self.images, self.names = [], [], []
    polish_divs.each do |polish_div|
      self.item_urls << "http://www.zoya.com" + polish_div.css("a").first.attributes["href"].value
      self.images << "http:" + polish_div.css("img").first.attributes["data-itemsrc"].value
      self.names << polish_div.attributes["data-itemname"].value
    end
  end

end

class ILNP
  
  URL = "http://www.ilnp.com/nail-polish.html?limit=20&p="
  attr_accessor :item_urls, :images, :names, :num_pages

  def initialize
    self.item_urls, self.images, self.names = [], [], []
    self.num_pages = 4
    scrape
  end

  def scrape
    1.upto num_pages do |page|
      doc = nokogiri_doc(page)
      polishes = get_polishes(doc)
      process_polishes(polishes)
    end
  end


  private
  
  def nokogiri_doc(page)
    Nokogiri::HTML(open(URL + page.to_s))
  end

  def get_polishes(doc)
    doc.css("li.item")
  end

  def process_polishes(polishes)
    polishes.each do |polish|
      unless name(polish).include? "Collection"
        save_data(polish)
      end
    end
  end

  def name(polish)
    polish.css("h2.product-name a").first.content
  end

  def save_data(polish)
    self.names << clean_name(polish)
    self.item_urls << polish_url(polish)
    self.images << image_url(polish)
  end

  def clean_name(polish)
    name(polish).sub(/\s\(.+\)\z/, "")
  end

  def polish_url(polish)
    polish.css("h2 a").first.attributes["href"].value
  end

  def image_url(polish)
    polish.css("div.product-image-wrapper a img").first.attributes["src"].value
  end

end

class ChinaGlaze
  
  URL = "http://chinaglaze.com/Colour/All-Colour/pageNum_"
  attr_accessor :item_urls, :images, :names, :num_pages

  def initialize
    self.item_urls, self.images, self.names = [], [], []
    self.num_pages = 5
    scrape
  end

  def scrape
    0.upto (num_pages-1) do |page|
      doc = nokogiri_doc(page)
      polishes = get_polishes(doc)
      process_polishes(polishes)
    end
  end


  private
  
  def nokogiri_doc(page)
    Nokogiri::HTML(open("#{URL}#{page}.html"))
  end

  def get_polishes(doc)
    doc.css("div.bottle")
  end

  def process_polishes(polishes)
    polishes.each { |polish| save_data(polish) }
  end

  def name(polish)
    polish.css("#color-name").first.content
  end

  def save_data(polish)
    self.names << clean_name(polish)
    self.item_urls << polish_url(polish)
    self.images << image_url(polish)
  end

  def clean_name(polish)
    name(polish).strip
  end

  def polish_url(polish)
    "http://chinaglaze.com" + polish.css("a").first.attributes["href"].value
  end

  def image_url(polish)
    "http://chinaglaze.com/uploads/products/bottle/#{image_filename(polish)}"
  end

  def image_filename(polish)
    polish.css("a img").first.attributes["src"].value.split("/").last
  end

end

class NailsInc
  
  URL = "https://us.nailsinc.com/products/?page="
  attr_accessor :item_urls, :images, :names, :num_pages

  def initialize
    self.item_urls, self.images, self.names = [], [], []
    self.num_pages = 6
    scrape
  end

  def scrape
    1.upto (num_pages) do |page|
      doc = nokogiri_doc(page)
      polishes = get_polishes(doc)
      process_polishes(polishes)
    end
  end

  private
  
  def nokogiri_doc(page)
    Nokogiri::HTML(open("#{URL}#{page}"))
  end

  def get_polishes(doc)
    doc.css("article.product a").select do |polish|
      polish.css("p.desc").text.include?("polish")
    end
  end

  def process_polishes(polishes)
    polishes.each { |polish| save_data(polish) }
  end

  def name(polish)
    polish.css(".title").text
  end

  def save_data(polish)
    self.names << clean_name(polish)
    self.item_urls << polish_url(polish)
    self.images << image_url(polish)
  end

  def clean_name(polish)
    name(polish).strip
  end

  def polish_url(polish)
    "https://us.nailsinc.com" + polish.attributes["href"].value
  end

  def image_url(polish)
    polish.css(".thumbnail").first.attributes.first[1].value
  end

end

class SeedDatabase
  def initialize
    #create_brands_colors_finishes
    seed_brands
  end

  BRAND_NAMES = ['Essie', 'OPI', 'Butter London', 'Deborah Lippmann', 'Zoya', 'China Glaze', 'I Love Nail Polish (ILNP)', 'Dior', 'Chanel', 'Formula X by Sephora', 'Sephora', 'Nails Inc.', 'Lancome', 'Nars', 'Mac', 'Nicole by OPI', 'Sally Hansen', 'Color Club', 'Orly', 'CND', 'Maybelline', "L’Oreal Paris", 'Revlon', 'CoverGirl', 'Sinful Colors', 'L.A. Colors', 'L.A. Girl', 'Wet N Wild', 'Brucci', 'Milani', 'Seche', 'New York Color', 'Stila', 'Obsessive Compulsive Cosmetics']

  COLOR_NAMES = ['red', 'beige', 'berry', 'brown', 'orange', 'coral', 'cream', 'fuchsia', 'lilac', 'mauve', 'turquoise', 'peach', 'tan', 'taupe', 'yellow', 'green', 'blue', 'teal', 'purple', 'magenta', 'pink', 'gray', 'black', 'white', 'nude', 'gold', 'bronze', 'copper', 'silver', 'neon', 'bright', 'dark']

  FINISH_DESCRIPTIONS = ['sheer', 'creme', 'shimmer', 'glitter', 'jelly', 'metallic', 'duochrome', 'holographic', 'multichrome', 'matte', 'semi-matte', 'frost', 'pearl', 'foil', 'satin', 'suede', 'flakies', 'glass-fleck', 'iridiscent', 'crackle', 'splatter', 'magnetic', 'texture', 'luminescent', 'other nail effects']

  def create_brands_colors_finishes
    [{"Brand" => BRAND_NAMES}, {"Color" => COLOR_NAMES}, {"Finish" => FINISH_DESCRIPTIONS}].each do |item|
      item.each do |category, names|
        names = names.sort
        names.each do |name|
          if ["Brand", "Color"].include?(category)
            Object.const_get(category).create(name: name)
          else
            Object.const_get(category).create(description: name)
          end
        end
      end
    end
  end

  BRAND_ATTRIBUTES_HASH = {
    # "OPI" => {class_name: Object.const_get("Opi")},
    # "Essie" => {class_name: Object.const_get("Essie")},
    # "Deborah Lippmann" => {class_name: Object.const_get("DeborahLippmann")},
    # "Butter London" => {class_name: Object.const_get("ButterLondon")},
    # "Zoya" => {class_name: Object.const_get("Zoya")}
    # "China Glaze" => {class_name: Object.const_get("ChinaGlaze")}
    "Nails Inc." => {class_name: Object.const_get("NailsInc")}
    # 'I Love Nail Polish (ILNP)' => {class_name: Object.const_get("ILNP")}
  }

  def seed_brands
    BRAND_ATTRIBUTES_HASH.each do |brand_name, attributes|
      brand = Brand.where(name: brand_name).first
      b = attributes[:class_name].new
      names = b.names
      urls = b.item_urls
      images = b.images
      names.each_with_index do |name, index|
        Lacquer.create(name: name, brand_id: brand.id, item_url: urls[index], default_picture: images[index])
      end
    end
  end

end

def get_bigger_deborah_images
  dl = Brand.find_by(name: "Deborah Lippmann")
  dl_lacquers = Lacquer.where(brand_id: dl.id)
  dl_lacquers.each do |lacquer|
    lacquer.update(default_picture: lacquer.default_picture.gsub('125x207', '244x400'))
  end
end

get_bigger_deborah_images
#SeedDatabase.new

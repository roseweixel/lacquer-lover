require 'fileutils'
require "addressable/uri"

class FormulaXbySephora
  
  URL = "http://www.sephora.com/formula-x-colors?icid2=brand_button_Formula%20X_The%20Colors"
  attr_accessor :item_urls, :images, :names, :num_pages

  def initialize
    self.item_urls, self.images, self.names = [], [], []
    scrape
  end

  def scrape
    doc = nokogiri_doc
    sku_ids = ["1547454",
 "1546852",
 "1547041",
 "1547702",
 "1547678",
 "1546811",
 "1547090",
 "1662956",
 "1547538",
 "1547660",
 "1546969",
 "1547066",
 "1547504",
 "1546837",
 "1579820",
 "1547280",
 "1547108",
 "1547462",
 "1546944",
 "1546936",
 "1547173",
 "1546993",
 "1547082",
 "1546829",
 "1547140",
 "1547496",
 "1662899",
 "1546761",
 "1547165",
 "1547298",
 "1546928",
 "1547488",
 "1547371",
 "1547330",
 "1547272",
 "1612944",
 "1547231",
 "1547637",
 "1547785",
 "1547447",
 "1547652",
 "1546951",
 "1547611",
 "1547603",
 "1662915",
 "1662923",
 "1547181",
 "1547710",
 "1547306",
 "1546977",
 "1547389",
 "1546753",
 "1547512",
 "1547033",
 "1546845",
 "1662931",
 "1547009",
 "1547561",
 "1547074",
 "1547769",
 "1546985",
 "1547215",
 "1662949",
 "1547645",
 "1547249",
 "1547207",
 "1547058",
 "1547587",
 "1547421",
 "1547348",
 "1546886",
 "1547223",
 "1547132",
 "1546860",
 "1547256",
 "1547363",
 "1547470",
 "1547355",
 "1547579",
 "1546878",
 "1547546",
 "1547686",
 "1547553",
 "1547595",
 "1546910",
 "1546894",
 "1547199",
 "1547322",
 "1547744",
 "1547413",
 "1662857",
 "1662840",
 "1662865",
 "1547736",
 "1547629",
 "1547520",
 "1547157",
 "1547025",
 "1547017",
 "1547751",
 "1547264",
 "1547405",
 "1547439"]
    get_polishes(sku_ids)
  end

  private
  
  def nokogiri_doc
    f = File.open('db/sephora.html')
    Nokogiri::HTML(f)
  end

  def get_sku_ids(doc)
    doc.css('.SkuItem-photo').collect{|item| item.children.css('a').first.attributes["href"].value.scan(/(?<=skuId=)\d+/)}.flatten
  end

  def get_polishes(sku_ids)
    (sku_ids + ["1547785", "1547397"]).each do |sku_id|
      url = "http://www.sephora.com/the-colors-P382111?skuId=#{sku_id}&icid2=Formula_X_the_colors_sku_grid_P382111_image"
      polish = Nokogiri::HTML(open(url))
      binding.pry
      if sku_id == "1662923"
        self.names << 'Lively'
      elsif sku_id == "1612944"
        self.names << 'Rouge'
      elsif sku_id == "1547785"
        self.names << 'Push The Limits'
      elsif name(polish) == 'A'
        self.names << 'A+'
      else
        self.names << name(polish)
      end
      self.item_urls << url
      self.images << "http://www.sephora.com/productimages/sku/s#{sku_id}-main-Lhero.jpg"
    end
  end

  def name(polish)
    polish.css('script[seph-json-to-js=sku]').text.split(",")[5].split(":")[1].scan(/\w+/).join(" ")
  end

end

class Nars
  
  URL = "http://www.narscosmetics.com/USA/nails"
  attr_accessor :item_urls, :images, :names, :num_pages

  def initialize
    self.item_urls, self.images, self.names = [], [], []
    scrape
  end

  def scrape
    doc = nokogiri_doc
    polishes = get_polishes(doc)
    process_polishes(polishes)
  end

  private
  
  def nokogiri_doc
    f = File.open('db/nars.html')
    Nokogiri::HTML(f)
  end

  def get_polishes(doc)
    doc.css('.product-tile').select{|tile| tile.text.include?('Nail Polish')}
  end

  def process_polishes(polishes)
    polishes.each do |polish|
      save_data(polish)
    end
  end

  def name(polish)
    polish.css('.name-link').text.strip.scan(/.+(?= \n)/).first
  end

  def save_data(polish)
    self.names << name(polish)
    self.item_urls << polish_url(polish)
    self.images << image_url(polish)
  end

  def polish_url(polish)
    polish.css('.name-link').first.attributes["href"].value
  end

  def image_url(polish)
    polish.css('img').first.attributes["src"].value
  end

end

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
    self.num_pages = 5
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

  COLOR_NAMES = ["red", "beige", "berry", "brown", "orange", "coral", "cream", "fuchsia", "lilac", "mauve", "turquoise", "peach", "tan", "taupe", "yellow", "green", "blue", "teal", "purple", "magenta", "pink", "gray", "black", "white", "nude", "gold", "bronze", "copper", "silver", "neon", "bright", "dark", "lavender", "crimson", "aqua", "mint", "navy", "pastel", "lemon", "lime", "blue-gray", "blush", "rose", "neutral", "warm", "cool", "charcoal", "cherry", "coffee", "salmon", "slate", "violet", "dusty", "fluorescent", "wine", "cyan", "indigo", "jade", "light", "deep"]

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
    # "Zoya" => {class_name: Object.const_get("Zoya")},
    # "China Glaze" => {class_name: Object.const_get("ChinaGlaze")},
    # "Nails Inc." => {class_name: Object.const_get("NailsInc")},
    # 'I Love Nail Polish (ILNP)' => {class_name: Object.const_get("ILNP")},
    # "Nars" => {class_name: Object.const_get("Nars")},
    "Formula X by Sephora" => {class_name: Object.const_get("FormulaXbySephora")}
  }

  def seed_brands
    BRAND_ATTRIBUTES_HASH.each do |brand_name, attributes|
      brand = Brand.where(name: brand_name).first
      b = attributes[:class_name].new
      names = b.names
      urls = b.item_urls
      images = b.images
      names.each_with_index do |name, index|
        existing_lacquer = Lacquer.find_by(name: name, brand_id: brand.id)
        if existing_lacquer
          # image = existing_lacquer.default_picture || images[index]
          existing_lacquer.update(item_url: urls[index], default_picture: images[index])
        else
          Lacquer.create(name: name, brand_id: brand.id, item_url: urls[index], default_picture: images[index])
        end
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

def format_butter_names
  butter = Brand.find_by(name: "Butter London")
  butter_lacquers = Lacquer.where(brand_id: butter.id)
  butter_lacquers.each do |lacquer|
    lacquer.update(name: lacquer.name.gsub(" Nail Lacquer", ""))
  end
end

def create_all_the_words
  Lacquer.all.each do |lacquer|
    lacquer.create_words
  end
end

def save_butter_images
  butter = Brand.find_by(name: "Butter London")
  butter_lacquers = Lacquer.where(brand_id: butter.id)
  butter_lacquers.each do |lacquer|
    url = lacquer.default_picture
    File.open("app/assets/images/lacquers/butter_london/#{lacquer.name.gsub(" ", "-").downcase}.png", 'wb') do |fo|
      fo.write open(url).read
    end
  end
end

def valid?(url)
  begin
    if url.class == Paperclip::Attachment || !url.start_with?("http")
      return true
    else
      uri = Addressable::URI.parse(url)
      request = Net::HTTP.new uri.host

      # rescue SocketError that occurs when offline
      response = request.request_head uri.path

      response.code.to_i == 200
    end
  rescue SocketError
    return false
  end
end

def rename_files_to_remove_weird_characters
  ['Formula X by Sephora'].each do |brand|
    Dir.foreach("app/assets/images/lacquers/#{brand.gsub(" ", "_").downcase}") do |item|
      if item != "." && item != ".." && File.basename(item) && item.gsub('.png', "").match(/(?!-)\W/)
        new_filename = item.gsub('.png', "").gsub(/(?!-)\W/, "")

        File.rename("app/assets/images/lacquers/#{brand.gsub(" ", "_").downcase}/#{item}", "app/assets/images/lacquers/#{brand.gsub(" ", "_").downcase}/#{new_filename}.png")
      end
    end
  end
end

def save_non_butter_images
  ['Formula X by Sephora'].each do |brand|
    current_brand = Brand.find_by(name: brand)
    current_brand_lacquers = Lacquer.where(brand_id: current_brand.id)
    current_brand_lacquers.each do |lacquer|
      url = lacquer.default_picture
      if valid?(url)
        dirname = File.dirname("app/assets/images/lacquers/#{brand.gsub(" ", "_").downcase}/#{lacquer.name.gsub(" ", "-").downcase}.png")
        unless File.directory?(dirname)
          FileUtils.mkdir_p(dirname)
        end
        File.open("app/assets/images/lacquers/#{brand.gsub(" ", "_").downcase}/#{lacquer.name.gsub(" ", "-").downcase}.png", 'wb') do |fo|
          fo.write open(url).read
        end
      else
        file = File.open("app/assets/images/lacquers/lacquers_with_invalid_images.txt", 'a')
        file << lacquer.name + " - " + lacquer.default_picture + "\n"
        file.close
      end
    end
  end
end

def update_all_default_pictures
  ['Formula X by Sephora'].each do |brand|
    current_brand = Brand.find_by(name: brand)
    current_brand_lacquers = Lacquer.where(brand_id: current_brand.id)
    current_brand_lacquers.each do |lacquer|
      aws_url = "https://s3.amazonaws.com/lacquer-love-and-lend-images/lacquers/images/#{brand.gsub(" ", "_").downcase}/#{lacquer.name.gsub(" ", "-").downcase.gsub(/(?!-)\W/, "")}.png"
      if valid?(aws_url)
        lacquer.default_picture = aws_url
        lacquer.save
      end
    end
  end
end

def store_missing_essie_images
  file = File.open("app/assets/images/lacquers/lacquers_with_invalid_images.txt")
  file.each_line do |line|
    url = line.scan(/(?<=new_valid_url: ).+/)[0].strip
    lacquer_name = line.scan(/.+(?= - )/)[0]
    File.open("app/assets/images/lacquers/essie/#{lacquer_name.gsub(" ", "-").gsub(/(?!-)\W/, "").downcase}.png", 'wb') do |fo|
      fo.write open(url).read
    end
  end
end

def get_correct_butter_urls
  butter = Brand.find_by(name: "Butter London")
  butter_lacquers = Lacquer.where(brand_id: butter.id)
  butter_lacquers.each do |lacquer|
    url = "http://www.butterlondon.com"+ lacquer.item_url
    lacquer.update(item_url: url)
  end
end

def clean_lacquer_names
  Lacquer.all.each do |lacquer|
    new_name = HTMLEntities.new.decode lacquer.name
    lacquer.update(name: new_name)
  end
end

def create_links_to_buy_on_amazon
  base_url = "http://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Dbeauty&field-keywords="
  Lacquer.all.each do |lacquer|
    lacquer.update(buy_url: base_url + "#{lacquer.brand.name.gsub(" ", "+")}+#{lacquer.name.gsub(" ", "+")}")
  end
end

# create_links_to_buy_on_amazon
# clean_lacquer_names
# save_butter_images
# save_non_butter_images
# rename_files_to_remove_weird_characters
# update_all_default_pictures
# store_missing_essie_images
# get_bigger_deborah_images
# format_butter_names
# create_all_the_words
# save_butter_images
# update_butter_default_pictures
# store_butter_images_as_paperclip_attachment
# get_correct_butter_urls
SeedDatabase.new

####
# Missing / Wrong Sephoras

# missing:
# Push The Limits
# http://www.sephora.com/the-colors-P382111?skuId=1547785&icid2=Formula_X_the_colors_sku_grid_P382111_image
# Pyrotechnic
# http://www.sephora.com/the-colors-P382111?skuId=1547397

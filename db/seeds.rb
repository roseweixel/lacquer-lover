class SeedDatabase
  def initialize
    create_brands
    create_colors
    create_finishes
    seed_deborah
    seed_opi
    seed_essie
    seed_butter
  end

  def create_brands
    brands = Brand.create([
      {name: 'Essie'},
      {name: 'OPI'},
      {name: 'Butter London'},
      {name: 'Deborah Lippmann'},
      {name: 'Zoya'},
      {name: 'China Glaze'},
      {name: 'I Love Nail Polish (ILNP)'},
      {name: 'Dior'},
      {name: 'Chanel'},
      {name: 'Formula X by Sephora'},
      {name: 'Sephora'},
      {name: 'Nails Inc.'},
      {name: 'Lancome'},
      {name: 'Nars'},
      {name: 'Mac'},
      {name: 'Nicole by OPI'},
      {name: 'Sally Hansen'},
      {name: 'Color Club'},
      {name: 'Orly'},
      {name: 'CND'},
      {name: 'Maybelline'},
      {name: "L'Oreal Paris"},
      {name: 'Revlon'},
      {name: 'CoverGirl'}
    ]).sort_by &:name
  end

  def create_colors
    colors = Color.create([
      {name: 'red'},
      {name: 'beige'},
      {name: 'berry'},
      {name: 'brown'},
      {name: 'orange'},
      {name: 'coral'},
      {name: 'cream'},
      {name: 'fuchsia'},
      {name: 'lilac'},
      {name: 'mauve'},
      {name: 'turquoise'},
      {name: 'peach'},
      {name: 'tan'},
      {name: 'taupe'},
      {name: 'yellow'},
      {name: 'green'},
      {name: 'blue'},
      {name: 'teal'},
      {name: 'purple'},
      {name: 'magenta'},
      {name: 'pink'},
      {name: 'gray'},
      {name: 'black'},
      {name: 'white'},
      {name: 'nude'},
      {name: 'gold'},
      {name: 'bronze'},
      {name: 'copper'},
      {name: 'silver'},
      {name: 'neon'},
      {name: 'bright'},
      {name: 'dark'}
    ]).sort_by &:name
  end

  def create_finishes
    finishes = Finish.create([
      {description: 'sheer'},
      {description: 'creme'},
      {description: 'shimmer'},
      {description: 'glitter'},
      {description: 'jelly'},
      {description: 'metallic'},
      {description: 'duochrome'},
      {description: 'holographic'},
      {description: 'multichrome'},
      {description: 'matte'},
      {description: 'semi-matte'},
      {description: 'frost'},
      {description: 'pearl'},
      {description: 'foil'},
      {description: 'satin'},
      {description: 'suede'},
      {description: 'flakies'},
      {description: 'iridiscent'},
      {description: 'crackle'},
      {description: 'splatter'},
      {description: 'magnetic'},
      {description: 'texture'},
      {description: 'luminescent'},
      {description: 'other nail effects'}
    ]).sort_by &:description
  end

  def seed_deborah
    brand = Brand.where(name: 'Deborah Lippmann').first
    d = DeborahLippmann.new
    deborah_names = d.names
    deborah_urls = d.item_urls
    deborah_images = d.images
    deborah_names.each_with_index do |name, index|
      Lacquer.create(name: name, brand_id: brand.id, item_url: deborah_urls[index], default_picture: deborah_images[index])
    end
  end

  def seed_opi
    brand = Brand.where(name: 'OPI').first
    o = Opi.new
    opi_names = o.names
    opi_urls = o.item_urls
    opi_images = o.images
    opi_names.each_with_index do |name, index|
      Lacquer.create(name: name, brand_id: brand.id, item_url: opi_urls[index], default_picture: opi_images[index])
    end
  end

  def seed_essie
    brand = Brand.where(name: 'Essie').first
    e = Essie.new
    essie_names = e.names
    essie_urls = e.item_urls
    essie_images = e.images
    essie_names.each_with_index do |name, index|
      Lacquer.create(name: name, brand_id: brand.id, item_url: essie_urls[index], default_picture: essie_images[index])
    end
  end

  def seed_butter
    brand = Brand.where(name: 'Butter London').first
    b = ButterLondon.new
    butter_names = b.names
    butter_urls = b.item_urls
    butter_images = b.images
    butter_names.each_with_index do |name, index|
      Lacquer.create(name: name, brand_id: brand.id, item_url: butter_urls[index], default_picture: butter_images[index])
    end
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
        @polish_names << butter_name
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

SeedDatabase.new

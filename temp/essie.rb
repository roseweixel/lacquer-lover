class Essie
  
  URL = "http://www.essie.com/Colors.aspx"
  attr_accessor :nokogiri_doc, :polish_urls, :polish_pics, :polish_names

  def initialize
    @nokogiri_doc = Nokogiri::HTML(open(URL))
    @polish_urls = []
    @polish_pics = []
    @polish_names = []
    @polish_colors = []
  end

  def item_url
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
    @polish_colors
    @polish_pics
  end

  def name
    polish_name = nokogiri_doc.css('div.product-wrapper a.bottle')
    polish_name.each do |item|
      essie_name = item.text
      @polish_names << essie_name
    end
    @polish_names
  end

end
require 'net/http'
module ApplicationHelper
 
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end
 
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end

  def display_image(user_lacquer)
    if user_lacquer.selected_display_image && user_lacquer.selected_display_image == user_lacquer.lacquer.default_picture
      picture_for(user_lacquer.lacquer)
    else
      image = user_lacquer.selected_display_image || user_lacquer.swatch_image
      if image
        image_tag(image, :height => "90")
      end
    end
  end

  def valid?(url)
    if url.class == Paperclip::Attachment || !url.start_with?("http")
      return true
    else
      uri = URI(url)
      request = Net::HTTP.new uri.host
      response= request.request_head uri.path

      response.code.to_i == 200
    end
  end

  def picture_for(lacquer)
    if lacquer.picture && valid?(lacquer.picture)
      begin 
        if lacquer.brand.name == "Zoya"
          image_tag(lacquer.picture, :size => "90x90", :class => "chunky_image")
        elsif lacquer.brand.name == "Essie"
          image_tag(lacquer.picture, :size => "42x90", :class => "padded_lacquer_pic")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.picture, :size => "40x90", :class => "padded_lacquer_pic")
        elsif lacquer.brand.name == "Deborah Lippmann"
          image_tag(lacquer.picture, :size => "55x90", :class => "padded_lacquer_pic")
        elsif lacquer.brand.name == "Butter London"
          image_tag(lacquer.picture, :size => "51x90", :class => "padded_lacquer_pic")
        elsif lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.picture, :size => "90x90", :class => "chunky_image")
        else
          image_tag(lacquer.picture, :size => "45x90", :class => "padded_lacquer_pic")
        end
      rescue
        image_tag('generic-polish.png', :size => "45x90", :class => "padded_lacquer_pic")
      end
    elsif lacquer.swatches.any?
      image_tag(lacquer.swatches.sample.image, :size => "45x90")
    else
      image_tag('generic-polish.png', :size => "45x90", :class => "padded_lacquer_pic")
    end
  end

  def large_picture_for(lacquer)
    if lacquer.picture && valid?(lacquer.picture)
      begin
        if lacquer.brand.name == "Deborah Lippmann" 
          image_tag(lacquer.picture, :size => "244x400")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.picture, :size => "164x400")
        elsif lacquer.brand.name == "Butter London"
          image_tag(lacquer.picture, :size => "232x400")
        elsif lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.picture, :size => "360x360", :class => "chunky_image_large")
        elsif lacquer.brand.name == "Zoya"
          image_tag(lacquer.picture, :size => "360x360", :class => "chunky_image_large")
        elsif lacquer.brand.name == "China Glaze"
          image_tag(lacquer.picture, :size => "176x400")
        elsif lacquer.brand.name == "Essie"
          image_tag(lacquer.picture, :size => "186x400")
        elsif lacquer.brand.name == "Nails Inc."
          image_tag(lacquer.picture, :size => "290x400")
        else
          image_tag(lacquer.picture, :size => "244x400")
        end
      rescue
        image_tag('generic-polish.png', :size => "244x400")
      end
    elsif lacquer.swatches.any?
      image_tag(lacquer.swatches.sample.image.url(:medium), :width => "244px")
    else
      image_tag('generic-polish.png', :size => "244x400")
    end
  end

  def small_picture_for(lacquer)
    if lacquer.picture && valid?(lacquer.picture)
      begin
        if lacquer.brand.name == "Deborah Lippmann" 
          image_tag(lacquer.picture, :size => "31x50", :class => "padded_lacquer_pic_small")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.picture, :size => "21x50", :class => "padded_lacquer_pic_small")
        elsif lacquer.brand.name == "Butter London"
          image_tag(lacquer.picture, :size => "29x50", :class => "padded_lacquer_pic_small")
        elsif lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.picture, :size => "50x50", :class => "chunky_image_small")
        elsif lacquer.brand.name == "Zoya"
          image_tag(lacquer.picture, :size => "50x50", :class => "chunky_image_small")
        elsif lacquer.brand.name == "China Glaze"
          image_tag(lacquer.picture, :size => "22x50", :class => "padded_lacquer_pic_small")
        elsif lacquer.brand.name == "Essie"
          image_tag(lacquer.picture, :size => "23x50", :class => "padded_lacquer_pic_small")
        elsif lacquer.brand.name == "Nails Inc."
          image_tag(lacquer.picture, :size => "36x50", :class => "padded_lacquer_pic_small")
        else
          image_tag(lacquer.picture, :size => "36x50", :class => "padded_lacquer_pic_small")
        end
      rescue
        image_tag('generic-polish.png', :size => "31x50", :class => "padded_lacquer_pic_small")
      end
    else
      image_tag('generic-polish.png', :size => "31x50", :class => "padded_lacquer_pic_small")
    end
  end
end

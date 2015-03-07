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

  def picture_for(lacquer)
    if lacquer.default_picture
      #binding.pry
      begin 
        #picture = open lacquer.default_picture
        if lacquer.brand.name == "Zoya"
          image_tag(lacquer.default_picture, :size => "90x90")
        elsif lacquer.brand.name == "Essie"
          image_tag(lacquer.default_picture, :size => "42x90")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.default_picture, :size => "40x90")
        elsif lacquer.brand.name == "Deborah Lippmann"
          image_tag(lacquer.default_picture, :size => "55x90")
        elsif lacquer.brand.name == "Butter London"
          image_tag(lacquer.default_picture, :size => "51x90")
        elsif lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.default_picture, :size => "90x90")
        else
          image_tag(lacquer.default_picture, :size => "45x90")
        end
      rescue
        image_tag('generic-polish.png', :size => "45x90")
      end
    else
      image_tag('generic-polish.png', :size => "45x90")
    end
  end

  def large_picture_for(lacquer)
    if lacquer.default_picture
      begin
        if lacquer.brand.name == "Deborah Lippmann" 
          image_tag(lacquer.default_picture, :size => "244x400")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.default_picture, :size => "164x400")
        elsif lacquer.brand.name == "Butter London"
          image_tag(lacquer.default_picture, :size => "232x400")
        elsif lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.default_picture, :size => "400x400", :class => "chunky_image")
        elsif lacquer.brand.name == "Zoya"
          image_tag(lacquer.default_picture, :size => "400x400", :class => "chunky_image")
        elsif lacquer.brand.name == "China Glaze"
          image_tag(lacquer.default_picture, :size => "176x400")
        elsif lacquer.brand.name == "Essie"
          image_tag(lacquer.default_picture, :size => "186x400")
        elsif lacquer.brand.name == "Nails Inc."
          image_tag(lacquer.default_picture, :size => "290x400")
        else
          image_tag(lacquer.default_picture, :size => "244x400")
        end
      rescue
        image_tag('generic-polish.png', :size => "244x400")
      end
    else
      image_tag('generic-polish.png', :size => "244x400")
    end
  end

  def small_picture_for(lacquer)
    if lacquer.default_picture
      begin
        if lacquer.brand.name == "Deborah Lippmann" 
          image_tag(lacquer.default_picture, :size => "31x50")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.default_picture, :size => "21x50")
        elsif lacquer.brand.name == "Butter London"
          image_tag(lacquer.default_picture, :size => "29x50")
        elsif lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.default_picture, :size => "50x50", :class => "chunky_image_small")
        elsif lacquer.brand.name == "Zoya"
          image_tag(lacquer.default_picture, :size => "50x50", :class => "chunky_image_small")
        elsif lacquer.brand.name == "China Glaze"
          image_tag(lacquer.default_picture, :size => "22x50")
        elsif lacquer.brand.name == "Essie"
          image_tag(lacquer.default_picture, :size => "23x50")
        elsif lacquer.brand.name == "Nails Inc."
          image_tag(lacquer.default_picture, :size => "290x400")
        else
          image_tag(lacquer.default_picture, :size => "36x50")
        end
      rescue
        image_tag('generic-polish.png', :size => "31x50")
      end
    else
      image_tag('generic-polish.png', :size => "31x50")
    end
  end
end

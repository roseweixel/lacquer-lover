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
      begin 
        picture = open lacquer.default_picture
        if lacquer.brand.name == "Zoya" || lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.default_picture, :size => "80x90")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.default_picture, :size => "40x90")
        elsif lacquer.brand.name == "Deborah Lippmann"
          image_tag(lacquer.default_picture, :size => "60x100")
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
end

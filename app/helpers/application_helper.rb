module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end

  def picture_for(lacquer)
    if lacquer.default_picture
      begin 
        picture = open lacquer.default_picture
        image_tag(lacquer.default_picture, :size => "45x90")
      rescue OpenURI::HTTPError
        image_tag('generic-polish.png', :size => "45x90")
      end
    else
      image_tag('generic-polish.png', :size => "45x90")
    end
  end
end

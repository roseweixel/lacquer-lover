require 'net/http'
require "addressable/uri"

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

  def name_links(users)
    users.any? ? users.collect{|user| link_to user.name, user_path(user)} : []
  end

  def transactions_categories
    [ 
      'transactions_for_your_approval', 
      'transactions_you_accepted', 
      'active_owned_transactions', 
      'active_requested_transactions', 
      'accepted_requested_transactions', 
      'pending_requested_transactions', 
      'rejected_requested_transactions',
      'lacquer_gifts_received_not_acknowledged' 
    ]
  end


  def header_text_for_transaction_category(trasaction_category)
    header_string_hash = { 
      "transactions_for_your_approval" => "Transactions Awaiting Your Approval",
      "transactions_you_accepted" => "Transactions You Accepted", 
      "active_owned_transactions" => "Lacquers Currently Loaned Out", 
      "active_requested_transactions" => "Lacquers You're Borrowing", 
      "accepted_requested_transactions" => "Accepted Loan Requests", 
      "pending_requested_transactions" => "Pending Loan Requests", 
      "rejected_requested_transactions" => "Rejected Loan Requests",
      "lacquer_gifts_received_not_acknowledged" => "You've Got Gifts!"
    }

    header_string_hash[trasaction_category]
  end

  def friendships_categories
    [ 
      'friendships_for_your_approval',
      'requested_friendships_awaiting_approval',
      'rejected_friend_requests'
    ]
  end

  def header_text_for_friendship_category(friendship_category)
    header_string_hash = { 
      "friendships_for_your_approval" => "Friendships Awaiting Your Approval",
      "requested_friendships_awaiting_approval" => "Your Pending Friend Requests", 
      "rejected_friend_requests" => "Sorry, these friend requests were not approved."
    }

    header_string_hash[friendship_category]
  end

  def is_an_email_address_not_noreply?(string)
    !!string.match(/[a-zA-Z\d]+\w*(?:\.\w+)*@[a-zA-Z\d-]+\.[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*/) && !string.match(/(noreply|no-reply)/i)
  end

  def is_an_email_address?(string)
    !!string.match(/[a-zA-Z\d]+\w*(?:\.\w+)*@[a-zA-Z\d-]+\.[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*/)
  end

  def display_image(user_lacquer)
    if user_lacquer.selected_display_image && user_lacquer.selected_display_image == user_lacquer.lacquer.default_picture
      picture_for(user_lacquer.lacquer)
    else
      image = user_lacquer.selected_display_image || user_lacquer.swatch_image
      if image
        image_tag(image, :width => "90")
      end
    end
  end

  def valid?(url)
    begin
      if url.start_with?("lacquers/")
        return false
      elsif url.class == Paperclip::Attachment || !url.start_with?("http")
        return true
      else
        uri = Addressable::URI.parse(url)

        request = Net::HTTP.new uri.host

        # rescue SocketError that occurs when offline
        response= request.request_head uri.path

        response.code.to_i == 200
      end
    rescue SocketError
      return false
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
      image_tag(lacquer.swatches.sample.image, :height => "90")
    else
      image_tag('generic-polish.png', :size => "45x90", :class => "padded_lacquer_pic")
    end
  end

  def large_picture_for(lacquer)
    if lacquer.picture && valid?(lacquer.picture)
      begin
        if lacquer.brand.name == "Deborah Lippmann" 
          image_tag(lacquer.picture, :size => "360x360", :class => "padded_lacquer_pic_large deborah")
        elsif lacquer.brand.name == "OPI"
          image_tag(lacquer.picture, :size => "360x360", :class => "padded_lacquer_pic_large opi")
        elsif lacquer.brand.name == "Butter London"
          image_tag(lacquer.picture, :size => "360x360", :class => "padded_lacquer_pic_large butter")
        elsif lacquer.brand.name == "I Love Nail Polish (ILNP)"
          image_tag(lacquer.picture, :size => "360x360", :class => "chunky_image_large")
        elsif lacquer.brand.name == "Zoya"
          image_tag(lacquer.picture, :size => "360x360", :class => "chunky_image_large")
        elsif lacquer.brand.name == "China Glaze"
          image_tag(lacquer.picture, :size => "360x360", :class => "padded_lacquer_pic_large")
        elsif lacquer.brand.name == "Essie"
          image_tag(lacquer.picture, :size => "360x360", :class => "padded_lacquer_pic_large essie")
        elsif lacquer.brand.name == "Nails Inc."
          image_tag(lacquer.picture, :size => "360x360", :class => "padded_lacquer_pic_large nailsinc")
        else
          image_tag(lacquer.picture, :size => "360x360", :class => "padded_lacquer_pic_large")
        end
      rescue
        image_tag('generic-polish.png', :size => "360x360", :class => "padded_lacquer_pic_large")
      end
    elsif lacquer.swatches.any?
      image_tag(lacquer.swatches.sample.image.url(:medium), :width => "360px", :height => "auto")
    else
      image_tag('generic-polish.png', :size => "360x360", :class => "padded_lacquer_pic_large")
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

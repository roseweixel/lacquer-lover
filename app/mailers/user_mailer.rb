class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  
  default from: "Lacquer Love&Lend <lacquerloveandlend@gmail.com>"

  def is_an_email_address_not_noreply?(string)
    !!string.match(/[a-zA-Z\d]+\w*(?:\.\w+)*@[a-zA-Z\d-]+\.[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*/) && !string.match(/(noreply|no-reply)/i)
  end

  # welcome on first login
  def welcome_email(user)
    @user = user
    @signin_url = "http://www.lacquerloveandlend.com/auth/facebook"
    
    mail(to: @user.email, subject: 'Welcome to Lacquer Love&Lend!', bcc: "lacquerloveandlend@gmail.com")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # email to invite other people who are not yet users
  def invite_email(user, emails)
    @user = user
    @friend_url = "http://www.lacquerloveandlend.com/friendships/new?friend_id=#{@user.id}"

    mail(to: emails, subject: "#{user.name} wants to share with you on Lacquer Love&Lend!", bcc: "lacquerloveandlend@gmail.com")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of friend request
  def friend_request_notification(user, friend)
    @user = user
    @friend = friend
    @friend_url = "http://www.lacquerloveandlend.com/friendships/new?friend_id=#{@user.id}"

    mail(to: @friend.email, subject: "#{@user.name} wants to be friends with you on Lacquer Love&Lend!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of friend request accepted
  def friend_request_accepted_notification(user, friend)
    @user = user
    @friend = friend
    @friend_url = "http://www.lacquerloveandlend.com/users/#{@friend.id}"

    mail(to: @user.email, subject: "#{@friend.name} accepted your friendship on Lacquer Love&Lend!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan request
  def loan_request_notification(owner, requester, user_lacquer)
    @owner = owner
    @requester = requester
    @user_lacquer = user_lacquer
    @user_url = "http://www.lacquerloveandlend.com/users/#{@owner.id}"

    mail(to: @owner.email, subject: "#{@requester.name} wants to borrow #{@user_lacquer.lacquer.name}")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan request accepted
  def loan_request_accepted_notification(transaction)
    @owner = transaction.owner
    @requester = transaction.requester
    @user_lacquer = transaction.user_lacquer

    mail(to: @requester.email, subject: "#{@owner.name} has agreed to loan you #{@user_lacquer.lacquer.name}!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan due date
  def loan_due_date_notification(transaction)
    @owner = transaction.owner
    @requester = transaction.requester
    @user_lacquer = transaction.user_lacquer
    @lacquer_name = @user_lacquer.lacquer.name
    @transaction = transaction
    @days_left = (transaction.due_date.to_date - Date.today).to_i

    mail(to: @requester.email, subject: "#{@lacquer_name} is due back to #{@owner.name} on #{@transaction.due_date.strftime("%m/%d/%Y")}.")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  def lacquer_returned_notification(transaction)
    @transaction = transaction
    @owner = transaction.owner
    @requester = transaction.requester
    @lacquer_name = @transaction.lacquer.name
    @owner_url = "http://www.lacquerloveandlend.com/users/#{@owner.id}"
    
    mail(to: @owner.email, subject: "Please confirm that #{@requester.name} has returned #{@lacquer_name}.")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  def transactional_message(from_name, bcc_email, reply_address, to_address, subject, body, transaction_id)
    @reply_address = reply_address
    @from_name = from_name
    @reply_url = "http://www.lacquerloveandlend.com/new_transactional_message?transaction_id=#{transaction_id}"
    @body = body

    mail(from: "#{from_name} via Lacquer Love&Lend <noreply@lacquerloveandlend.com>", :reply_to => reply_address, :to => to_address, :subject => subject, :bcc => bcc_email)
    
    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan turned into gift?
  def gift_notification(gift)
    @requester = gift.requester
    @owner = gift.owner
    @lacquer = gift.lacquer
    @user_url = "http://www.lacquerloveandlend.com/users/#{@requester.id}"
    @thank_you_email_url = "http://www.lacquerloveandlend.com/new_transactional_message?gift_id=#{gift.id}"

    mail(to: @requester.email, subject: "You've received a gift on Lacquer Love&Lend!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  def user_feedback_email(reply_address, to_address, subject, body, bcc)

    mail(to: to_address, reply_to: reply_address, subject: subject, body: body, bcc: bcc)

    headers['X-MC-Track'] = "opens, clicks_all"
  end
  

end

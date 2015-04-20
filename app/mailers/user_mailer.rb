class UserMailer < ActionMailer::Base
  default from: "Lacquer Love&Lend <lacquerloveandlend@gmail.com>"

  # Emails to send:

  # welcome on first login
  def welcome_email(user)
    @user = user
    @signin_url = "http://lacquer-love-and-lend.herokuapp.com/auth/facebook"
    
    mail(to: @user.email, subject: 'Welcome to Lacquer Love&Lend!', bcc: "lacquerloveandlend@gmail.com")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # email to invite other people who are not yet users
  def invite_email(user, emails)
    @user = user
    @friend_url = "http://lacquer-love-and-lend.herokuapp.com/friendships/new?friend_id=#{@user.id}"

    mail(to: emails, subject: "#{user.name} wants to share with you on Lacquer Love&Lend!", bcc: "lacquerloveandlend@gmail.com")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of friend request
  def friend_request_notification(user, friend)
    @user = user
    @friend = friend
    @friend_url = "http://localhost:3000/friendships/new?friend_id=#{@user.id}"

    mail(to: @friend.email, subject: "#{@user.name} wants to be friends with you on Lacquer Love&Lend!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of friend request accepted
  def friend_request_accepted_notification(user, friend)
    @user = user
    @friend = friend
    @friend_url = "http://localhost:3000/users/#{@friend.id}"

    mail(to: @user.email, subject: "#{@friend.name} accepted your friendship on Lacquer Love&Lend!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan request
  # notif of loan request accepted
  # notif of loan turned into gift?
  

end

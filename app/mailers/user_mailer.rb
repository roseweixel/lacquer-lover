class UserMailer < ActionMailer::Base
  default from: "Lacquer Love&Lend <lacquerloveandlend@gmail.com>"

  # Emails to send:

  # welcome on first login
  def welcome_email(user)
    @user = user
    @signin_url = "http://lacquer-love-and-lend.herokuapp.com/auth/facebook"
    mail(to: @user.email, subject: 'Welcome to Lacquer Love&Lend!')

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  def invite_email(user, emails)
    @user = user
    @friend_url = "http://lacquer-love-and-lend.herokuapp.com/friendships/new?friend_id=#{@user.id}"
    mail(to: emails, subject: "#{user.name} wants to share with you on Lacquer Love&Lend!", bcc: "lacquerloveandlend@gmail.com")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan request
  # notif of loan request accepted
  # notif of loan turned into gift?
  # notif of friend request
  # notif of friend request accepted

end

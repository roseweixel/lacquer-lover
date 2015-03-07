jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true


window.fbAsyncInit = ->
  # localhost, testing
  # FB.init(appId: '1740995652791642', cookie: true)
  
  # # Heroku
  FB.init(appId: '1737505913140616', cookie: true)

  $('#sign_in').click (e) ->
    e.preventDefault()
    FB.login ((response) ->
          window.location = '/auth/facebook/callback' if response.authResponse), scope: "email"

  $('#sign_out').click (e) ->
    FB.getLoginStatus (response) ->
      FB.logout() if response.authResponse
    true

json.extract! @user, :id, :name
json.lacquer_count @user.lacquers.count

json.lacquers @user.user_lacquers do |user_lacquer|
  @lacquer = user_lacquer.lacquer
  json.brand @lacquer.brand.name
  json.name @lacquer.name
  json.colors user_lacquer.colors.pluck(:name)
  json.finishes user_lacquer.finishes.pluck(:description)
  json.extract! user_lacquer, :loanable, :on_loan
end
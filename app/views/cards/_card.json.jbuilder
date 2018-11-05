json.extract! card, :id, :last_4, :card_type, :issuer
json.status card.status # TODO: uncomment this: if current_user.admin?
json.expiration_year card.expiration.strftime("%Y")
json.expiration_month card.expiration.strftime("%m")
json.url user_card_url(card.user, card, format: :json)

json.extract! token, :token, :token_type, :expires_at
json.user do
  json.email token.user.email
end
json.url token_url(token, format: :json)

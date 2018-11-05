json.extract! user, :id, :email, :first_name, :last_name, :role, :status, :created_at, :updated_at
json.account do
  json.partial!('accounts/account', account: user.account) if user.account.present?
end
json.url user_url(user, format: :json)

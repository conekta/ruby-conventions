# Test admin user with a default internal account
admin_args = {
  email: "admin@walletapi.xyz",
  password: "Testing@123!",
  password_confirmation: "Testing@123!",
  first_name: "Admin",
  last_name: "User",
  role: User.roles[:admin],
  status: User.statuses[:active]
}
if User.where(email: admin_args[:email]).empty?
  admin = User.create(admin_args)
  account_args = {
    balance: 1000000,
    account_type: Account.account_types[:internal]
  }
  admin.create_account(account_args)
end

[
  {
    description: "0 to $1,000 fee",
    lower_range: 0,
    upper_range: 1000,
    flat_fee: 8.0,
    variable_fee: 3.0
  },
  {
    description: "$1,001 to $5,000 fee",
    lower_range: 1001.00,
    upper_range: 5000.00,
    flat_fee: 6.0,
    variable_fee: 2.5
  },
  {
    description: "$5,001 to $10,000 fee",
    lower_range: 5001.00,
    upper_range: 10000.00,
    flat_fee: 4.0,
    variable_fee: 2.0
  },
  {
    description: "$10,001 to $99,999,999.99 fee",
    lower_range: 10000.00,
    upper_range: 99999999.99,
    flat_fee: 3.0,
    variable_fee: 1.0
  }
].each do |fee|
  Fee.find_or_create_by(fee)
end

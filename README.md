# Wallet API

This is a sample application written in ruby on rails to showcase a demo of an e-wallet REST API where customers can transfer money between wallets or deposit/withdraw to a credit or debit card.

## Dependencies

This application uses the usual suspects: ruby, rails and postgres. There are no specific requirements other than running a recent version of ruby, preferably one above 2.1

## Configuration

We are using dotenv to manage settings locally and for testing, that way we can simply reference `ENV['VARIABLE']` within our code. There is an included `env.example` file that you can use as a base to modify it for your own settings. Use a `.env.development` for development and `.env.test` for testing.

Once you setup the env vars do the usual dance:

```
bundle install
rails db:drop db:create db:migrate
```

If you want some test data make sure you also seed the database:

```
rails db:seed
```

To create a bunch of test users and the ranges for fees.

## Testing

Run:

```
rspec
```

## Running

```
rails server
```

That's it!

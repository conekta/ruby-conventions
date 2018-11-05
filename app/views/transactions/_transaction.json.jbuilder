json.id transaction.id
json.amount transaction.amount
json.type transaction.transaction_type
json.description transaction.description
json.reference transaction.reference.try(:id).try(:first, 8)
json.balance transaction.user_balance
json.created_at transaction.created_at
json.transferable do
  json.id transaction.transferable.id
end unless transaction.internal?
json.url user_transaction_url(transaction.user, transaction, format: :json)

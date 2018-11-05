json.extract! fee, :id, :description, :lower_range, :upper_range, :flat_fee, :variable_fee, :created_at, :updated_at
json.url fee_url(fee, format: :json)

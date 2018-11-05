FactoryBot.define do
  factory :fee do
    sequence(:description) { |n| "Fee #{n}" }
    lower_range { 0 }
    upper_range { 1000 }
    flat_fee { 8.00 }
    variable_fee { 3.00 }
  end
end

class Account < ApplicationRecord
  belongs_to :user

  enum account_type: {
    customer: 0,
    internal: 1
  }

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true
  validates :account_type, presence: true, inclusion: { in: self.account_types.keys }
end

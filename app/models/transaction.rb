class Transaction < ApplicationRecord

  include Concerns::Paginable

  belongs_to :transferable, polymorphic: true, autosave: true
  belongs_to :user, optional: true
  belongs_to :reference, class_name: 'Transaction', foreign_key: :reference_id, optional: true

  enum transaction_type: {
    transfer: 0,
    deposit: 1,
    withdrawal: 2,
    flat_fee: 3,
    variable_fee: 4
  }

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transferable_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :reference, presence: true, if: :internal?
  validates :transaction_type, presence: true, inclusion: { in: self.transaction_types.keys }

  def internal?
    flat_fee? || variable_fee?
  end
end

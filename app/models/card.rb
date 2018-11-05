class Card < ApplicationRecord

  include Concerns::Paginable

  belongs_to :user

  ISSUERS = %w(amex visa mastercard dinners discover)

  enum card_type: {
    credit: 0,
    debit: 1
  }

  enum status: {
    active: 0,
    removed: 1
  }

  validates :card_type, presence: true, inclusion: { in: self.card_types.keys }
  validates :last_4, presence: true, length: { is: 4 }
  validates :issuer, presence: true, inclusion: { in: ISSUERS }
  validates :status, presence: true, inclusion: { in: self.statuses.keys }
  validates :user, presence: true
  validates :expiration, presence: true
  validates :bank_token, presence: true

  before_validation :override_expiration_day
  before_validation :enable_card, on: :create
  before_destroy :check_transactions

  scope :expired, -> { where("expiration <= ?", Time.now.strftime("%Y/%m/%d")) }

  def has_transactions?
    Transaction.where(transferable: self).exists?
  end

  private

  def check_transactions
    if has_transactions?
      errors.add(:base, "This card has transactions so it cannot be physically removed, set it as removed instead.")
      throw(:abort)
    end
  end

  def override_expiration_day
    if expiration.present?
      self.expiration = self.expiration.strftime("%Y/%m/01")
    end
  end

  def enable_card
    self.status = Card.statuses[:active]
  end

end

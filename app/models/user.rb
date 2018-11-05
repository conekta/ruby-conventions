class User < ApplicationRecord

  include Concerns::Paginable

  has_many :tokens, dependent: :destroy
  has_one :account, dependent: :destroy, autosave: true
  has_many :cards, dependent: :destroy
  has_many :transactions

  has_secure_password

  enum role: {
    customer: 0,
    admin: 1
  }

  enum status: {
    active: 0,
    unconfirmed: 1,
    disabled: 2,
    removed: 3
  }

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true, inclusion: { in: self.roles.keys }
  validates :status, presence: true, inclusion: { in: self.statuses.keys }  
  validates :password, length: { minimum: 8 }, allow_nil: true

  delegate :balance, to: :account, allow_nil: true

  def valid_token_for(token_type, token)
    tokens.where(token_type: Token.token_types[token_type.to_sym], token: token).first
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

end

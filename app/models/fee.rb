class Fee < ApplicationRecord

  include Concerns::Paginable

  validates :description, presence: true, uniqueness: true
  validates :lower_range, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :upper_range, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :flat_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :variable_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :valid_range, if: lambda { self.lower_range.present? && self.upper_range.present? }

  def self.within_range(amount)
    where("(#{amount} BETWEEN lower_range AND upper_range)").first
  end

  private

  def valid_range
    lower_exist = Fee.where("(lower_range BETWEEN #{lower_range} AND #{upper_range})").where.not(id: id).exists?
    upper_exist = Fee.where("(upper_range BETWEEN #{lower_range} AND #{upper_range})").where.not(id: id).exists?
    errors.add(:lower_range, "there is already a fee that spans this lower range") if lower_exist
    errors.add(:upper_range, "there is already a fee that spans this upper range") if lower_exist
  end

end

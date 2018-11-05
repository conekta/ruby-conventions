require 'rails_helper'

RSpec.describe Fee, type: :model do
  subject { FactoryBot.build :fee }

  describe :validations do
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:description) }
    it { should validate_presence_of(:lower_range) }
    it { should validate_numericality_of(:lower_range).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:upper_range) }
    it { should validate_numericality_of(:upper_range).is_greater_than_or_equal_to(1) }
    it { should validate_presence_of(:flat_fee) }
    it { should validate_numericality_of(:flat_fee).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:variable_fee) }
    it { should validate_numericality_of(:variable_fee).is_greater_than_or_equal_to(0) }    

    it "should validate the upper and lower ranges" do
      FactoryBot.create(:fee, lower_range: 0, upper_range: 1000)
      FactoryBot.create(:fee, lower_range: 1001, upper_range: 5000)
      subject.lower_range = 900
      subject.upper_range = 2000
      subject.valid?
      expect(subject.errors[:lower_range]).to_not be_empty
      expect(subject.errors[:upper_range]).to_not be_empty
    end
  end
end

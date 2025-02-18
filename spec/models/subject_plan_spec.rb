require 'rails_helper'

RSpec.describe SubjectPlan, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:subject) }
  end

  describe 'validations' do
    subject { create :subject_plan }

    it {
      is_expected.to validate_uniqueness_of(:subject_id)
        .scoped_to(:user_id)
    }
    it { is_expected.to validate_numericality_of(:semester).only_integer.is_greater_than(0) }
  end
end

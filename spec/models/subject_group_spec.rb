require 'rails_helper'

RSpec.describe SubjectGroup, type: :model do
  subject { build :subject_group }

  describe 'associations' do
    it { should belong_to(:degree) }
    it {
      should have_many(:subjects).with_foreign_key('group_id').inverse_of(:group).dependent(:restrict_with_exception)
    }
    it { should have_many(:subject_group_memberships).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:code).scoped_to(:degree_plan_id) }
  end
end

require 'rails_helper'

RSpec.describe SubjectGroupMembership, type: :model do
  subject { build :subject_group_membership }

  describe 'associations' do
    it { should belong_to(:subject) }
    it {
      should belong_to(:group)
        .class_name('SubjectGroup')
        .inverse_of(:subject_group_memberships)
    }
  end

  describe 'validations' do
    it { should validate_presence_of(:credits) }
  end
end

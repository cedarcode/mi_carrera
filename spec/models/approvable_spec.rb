require 'rails_helper'

RSpec.describe Approvable, type: :model do
  describe 'associations' do
    it { should belong_to(:subject) }
    it { should have_one(:prerequisite_tree).class_name('Prerequisite').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:is_exam).in_array([true, false]) }
  end
end

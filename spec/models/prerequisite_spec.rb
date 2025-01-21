require 'rails_helper'

RSpec.describe Prerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:parent_prerequisite).class_name('Prerequisite').optional }
    it { should belong_to(:approvable).optional }
  end
end

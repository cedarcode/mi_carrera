require 'rails_helper'

RSpec.describe SubjectPrerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:approvable_needed).class_name('Approvable') }
  end
end

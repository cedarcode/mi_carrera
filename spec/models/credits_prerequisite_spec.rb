require 'rails_helper'

RSpec.describe CreditsPrerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:subject_group).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:credits_needed) }
  end
end

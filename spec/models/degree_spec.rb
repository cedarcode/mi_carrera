require 'rails_helper'

RSpec.describe Degree, type: :model do
  describe 'associations' do
    it { should have_many(:users).dependent(:nullify) }
    it { should have_many(:subjects).dependent(:destroy) }
    it { should have_many(:subject_groups).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create :degree }

    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key) }
  end
end

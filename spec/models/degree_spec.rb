require 'rails_helper'

RSpec.describe Degree, type: :model do
  describe 'associations' do
    it { should have_many(:users).dependent(:nullify) }
  end

  describe 'validations' do
    subject { create :degree }

    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key) }
  end
end

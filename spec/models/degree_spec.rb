require 'rails_helper'

RSpec.describe Degree, type: :model do
  describe 'validations' do
    subject { described_class.new(key: 'foo') }

    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
  end
end

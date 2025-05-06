require 'rails_helper'

RSpec.describe Degree, type: :model do
  describe 'validations' do
    subject { described_class.new(key: 'foo') }

    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
  end

  describe 'callbacks' do
    let(:key) { 'foo' }

    it 'calls create_tenant after creation' do
      expect_any_instance_of(described_class).to receive(:create_tenant)
      Degree.create!(key: key)
    end
  end

  describe '#create_tenant' do
    let(:degree) { Degree.new(key: 'foo') }

    it 'calls Apartment::Tenant.create with the key' do
      expect(Apartment::Tenant).to receive(:create).with('foo')
      degree.send(:create_tenant)
    end
  end
end

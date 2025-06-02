require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:subject_plans).dependent(:destroy) }
    it { should have_many(:planned_subjects).through(:subject_plans).source(:subject) }
    it { should belong_to(:degree).optional }
    it { should have_many(:degree_subjects).through(:degree).source(:subjects) }
    it { should have_many(:degree_subject_groups).through(:degree).source(:subject_groups) }
  end

  describe '.from_omniauth' do
    context 'when user does not exist' do
      it 'creates a new user' do
        auth = OmniAuth::AuthHash.new(
          provider: 'google',
          uid: '123456789',
          info: OmniAuth::AuthHash::InfoHash.new(
            email: 'user1@gmail.com'
          )
        )

        new_user = described_class.from_omniauth(auth, {})

        expect(new_user).to be_persisted
        expect(new_user.email).to eq(auth.info.email)
        expect(new_user.provider).to eq(auth.provider)
        expect(new_user.uid).to eq(auth.uid)
      end
    end

    context 'when user exists' do
      it 'updates the existing user' do
        user = create(:user)

        auth = OmniAuth::AuthHash.new(
          provider: 'google',
          uid: '123456789',
          info: OmniAuth::AuthHash::InfoHash.new(
            email: user.email
          )
        )

        existing_user = described_class.from_omniauth(auth, {})

        expect(existing_user).to be_persisted
        expect(existing_user.id).to eq(user.id)
        expect(existing_user.email).to eq(auth.info.email)
        expect(existing_user.provider).to eq(auth.provider)
        expect(existing_user.uid).to eq(auth.uid)
      end
    end
  end

  describe '#degree_subjects' do
    let(:user) { create(:user, degree:) }

    context 'when user has a degree' do
      let(:degree) { create(:degree) }
      let(:subject1) { create(:subject, degree:) }
      let(:subject2) { create(:subject) }

      it 'returns the associated degree_subjects' do
        expect(user.degree_subjects).to eq([subject1])
      end
    end

    context 'when user has no degree' do
      let(:degree) { nil }
      it 'returns the Subject model' do
        expect(user.degree_subjects).to eq(Subject)
      end
    end
  end

  describe '#degree_subject_groups' do
    let(:user) { create(:user, degree:) }

    context 'when user has a degree' do
      let(:degree) { create(:degree) }
      let(:subject_group1) { create(:subject_group, degree:) }
      let(:subject_group2) { create(:subject_group) }

      it 'returns the associated degree_subject_groups' do
        expect(user.degree_subject_groups).to eq([subject_group1])
      end
    end

    context 'when user has no degree' do
      let(:degree) { nil }
      it 'returns the SubjectGroup model' do
        expect(user.degree_subject_groups).to eq(SubjectGroup)
      end
    end
  end
end

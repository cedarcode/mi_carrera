require 'test_helper'

class CreditsPrerequisiteTest < ActiveSupport::TestCase
  test "#met? returns true when credits >= needed" do
    prerequisite = build :credits_prerequisite, credits_needed: 2
    s_2_credits = create :subject, credits: 2
    s_3_credits = create :subject, credits: 3
    assert prerequisite.met?([s_2_credits.course.id])
    assert prerequisite.met?([s_3_credits.course.id])
  end

  test "#met? returns false when credits < needed" do
    prerequisite = build :credits_prerequisite, credits_needed: 2
    s_1_credits = create :subject, credits: 1
    assert_not prerequisite.met?([s_1_credits.course.id])
  end

  test "#met? returns true when credits >= needed with subject_group and other subjects" do
    group = create :subject_group
    s1_with_group = create :subject, credits: 2, group: group
    s2_with_group = create :subject, credits: 3, group: group
    s3_without_group = create :subject, credits: 3
    prerequisite = build :credits_prerequisite, credits_needed: 5, subject_group: group
    assert prerequisite.met?([s1_with_group.course.id, s2_with_group.course.id, s3_without_group.course.id])
  end

  test "#met? returns false when credits < needed with subject_group and other subjects" do
    group = create :subject_group
    s1_with_group = create :subject, credits: 2, group: group
    s3_without_group = create :subject, credits: 3
    prerequisite = build :credits_prerequisite, credits_needed: 5, subject_group: group
    assert_not prerequisite.met?([s1_with_group.course.id, s3_without_group.course.id])
  end
end

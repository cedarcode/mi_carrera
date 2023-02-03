class ProfilesController < ApplicationController
  def show
    @groups_and_credits = SubjectGroup.find_each.map do |subject_group|
      { subject_group:, credits: current_student.group_credits(subject_group) }
    end

    respond_to do |format|
      format.html
    end
  end
end

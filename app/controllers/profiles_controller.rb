class ProfilesController < ApplicationController
  def show
    @groups_and_credits = current_degree.subject_groups.find_each.map do |subject_group|
      credits = current_student.group_credits(subject_group)
      {
        subject_group:,
        credits:,
        credits_needed_reached: credits >= subject_group.credits_needed,
      }
    end

    @all_group_credits_met = @groups_and_credits.all? { |group_and_credits| group_and_credits[:credits_needed_reached] }
    @total_credits = @groups_and_credits.pluck(:credits).sum

    respond_to do |format|
      format.html
    end
  end
end

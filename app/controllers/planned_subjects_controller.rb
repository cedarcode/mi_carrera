class PlannedSubjectsController < ApplicationController
  def create
    current_user.planned_subjects.create(subject_id: params[:subject_id])
  end
end

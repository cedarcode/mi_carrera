class PlannedSubjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @planned_subjects, @not_planned_subjects = TreePreloader.new.preload.partition do |subject|
      current_student.approved?(subject.course) ||
        current_user.planned_subjects.any? { |planned_subject| planned_subject.subject_id == subject.id }
    end
  end

  def create
    current_user.planned_subjects.create(subject_id: params[:subject_id])

    @planned_subjects, @not_planned_subjects = TreePreloader.new.preload.partition do |subject|
      current_student.approved?(subject.course) ||
        current_user.planned_subjects.any? { |planned_subject| planned_subject.subject_id == subject.id }
    end

    render :create
  end

  def destroy
    planned_subject = current_user.planned_subjects.find_by!(subject_id: params[:subject_id])
    planned_subject.destroy

    @planned_subjects, @not_planned_subjects = TreePreloader.new.preload.partition do |subject|
      current_student.approved?(subject.course) ||
        current_user.planned_subjects.any? { |planned_subject| planned_subject.subject_id == subject.id }
    end

    render :destroy
  end
end

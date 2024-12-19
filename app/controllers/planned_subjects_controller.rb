class PlannedSubjectsController < ApplicationController
  def index
    @planned_subjects = TreePreloader.new.preload.select do |subject|
      current_student.approved?(subject.course) ||
        current_user.planned_subjects.any? { |planned_subject| planned_subject.subject_id == subject.id }
    end

    @not_planned_subjects = TreePreloader.new.preload - @planned_subjects
  end

  def create
    current_user.planned_subjects.create(subject_id: params[:subject_id])

    @planned_subjects = TreePreloader.new.preload.select do |subject|
      current_student.approved?(subject.course) ||
        current_user.planned_subjects.any? { |planned_subject| planned_subject.subject_id == subject.id }
    end

    @not_planned_subjects = TreePreloader.new.preload - @planned_subjects

    render :create
  end

  def destroy
    planned_subject = current_user.planned_subjects.find_by!(subject_id: params[:subject_id])
    planned_subject.destroy

    @planned_subjects = TreePreloader.new.preload.select do |subject|
      current_student.approved?(subject.course) ||
        current_user.planned_subjects.any? { |planned_subject| planned_subject.subject_id == subject.id }
    end

    @not_planned_subjects = TreePreloader.new.preload - @planned_subjects

    render :destroy
  end
end

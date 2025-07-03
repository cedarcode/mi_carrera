class SubjectsController < ApplicationController
  def index
    @subjects = TreePreloader.preload(degree_subjects.ordered_by_category_and_name).select do |subject|
      current_student.approved?(subject.course) ||
        (!subject.hidden_by_default? && current_student.available?(subject.course))
    end
  end

  def show
    @user_review = current_user.reviews.find_by(subject:) if current_user

    respond_to do |format|
      format.html { subject }
    end
  end

  def all
    subjects =
      if params[:search].present?
        degree_subjects.search(params[:search])
      else
        degree_subjects
      end.ordered_by_category_and_name

    @subjects = TreePreloader.preload(subjects)
  end

  private

  def subject
    @subject ||= degree_subjects.find(params[:id])
  end

  def degree_subjects
    current_degree.subjects
  end
end

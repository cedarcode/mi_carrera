class SubjectsController < ApplicationController
  before_action :set_filter_categories, only: [:index]

  def index
    subjects = degree_subjects.where(category: @filter_categories).ordered_by_category_and_name
    @subjects = TreePreloader.preload(subjects).select do |subject|
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

  def set_filter_categories
    @filter_categories = params[:filter_categories] || Subject::MAIN_CATEGORIES
  end
end

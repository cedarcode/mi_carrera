class SubjectsController < ApplicationController
  def index
    @subjects = TreePreloader.new(degree_subjects.ordered_by_category_and_name).preload.select do |subject|
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
        degree_subjects
          .where("lower(unaccent(name)) LIKE lower(unaccent(?))", "%#{params[:search].strip}%")
          .or(degree_subjects.where("lower(unaccent(short_name)) LIKE lower(unaccent(?))",
                                    "%#{params[:search].strip}%"))
          .or(degree_subjects.where("lower(code) LIKE lower(?)", "%#{params[:search].strip}%"))
      else
        degree_subjects
      end.ordered_by_category_and_name

    @subjects = TreePreloader.new(subjects).preload
  end

  private

  def subject
    @subject ||= degree_subjects.find(params[:id])
  end

  def degree_subjects
    current_student.degree_subjects
  end
end

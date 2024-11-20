class SubjectsController < ApplicationController
  def index
    @subjects = TreePreloader.new.preload.select do |subject|
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
        Subject
          .where("lower(unaccent(name)) LIKE lower(unaccent(?))", "%#{params[:search].strip}%")
          .or(Subject.where("lower(unaccent(short_name)) LIKE lower(unaccent(?))", "%#{params[:search].strip}%"))
      end

    @subjects = TreePreloader.new(subjects).preload
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end
end

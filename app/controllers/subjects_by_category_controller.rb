class SubjectsByCategoryController < ApplicationController
  def index
    subjects =
      if params[:search].present?
        Subject
          .where("lower(unaccent(name)) LIKE lower(unaccent(?))", "%#{params[:search].strip}%")
          .or(Subject.where("lower(unaccent(short_name)) LIKE lower(unaccent(?))", "%#{params[:search].strip}%"))
          .or(Subject.where("lower(code) LIKE lower(?)", "%#{params[:search].strip}%"))
      else
        Subject
      end.ordered_by_category_and_name

    @category = params[:category].presence || 'first_semester'
    subjects = subjects.where(category: @category)

    @subjects = TreePreloader.new(subjects).preload
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end
end

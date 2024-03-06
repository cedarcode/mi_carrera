class SubjectsController < ApplicationController
  def index
    @subjects = TreePreloader.new.preload.select do |subject|
      current_student.approved?(subject.course) ||
        (!subject.hidden_by_default? && current_student.available?(subject.course))
    end
  end

  def show
    respond_to do |format|
      format.html { subject }
    end
  end

  def all
    @subjects =
      begin
        subjects =
          if params[:search].present?
            Subject.where("lower(unaccent(name)) LIKE lower(unaccent(?))", "%#{params[:search]}%")
          end

        TreePreloader.new(subjects).preload
      end
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end
end

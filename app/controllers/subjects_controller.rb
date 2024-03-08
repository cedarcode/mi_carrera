class SubjectsController < ApplicationController
  def index
    @groups = []
    @categories = []
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
    subjects = Subject.all
    subjects = subjects.where(category: params[:categories]) if params[:categories].present?
    subjects = subjects.joins(:group).where(group: { name: params[:groups] }) if params[:groups].present?
    subjects = subjects.where("lower(unaccent(name)) LIKE lower(unaccent(?))", "%#{params[:search].strip}%") if params[:search].present?
    
    @groups = params[:groups] || []
    @categories = params[:categories] || []
    @subjects = TreePreloader.new(subjects).preload
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end
end

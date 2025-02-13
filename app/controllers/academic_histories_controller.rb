require 'pdf-reader'

class AcademicHistoriesController < ApplicationController
  def index
    redirect_to new_academic_history_path
  end

  def new
  end

  def create
    file = params[:file]
    @failed_entries = []
    @successful_entries = []

    if file && file.content_type == 'application/pdf'
      @academic_entries = AcademicHistory::PdfProcessor.process(file)
      @academic_entries.each do |entry|
        save_academic_entry(entry) if entry.approved?
      end
    else
      flash[:error] = 'Please upload a valid PDF file'
    end
    render :new
  end

  private

  def save_academic_entry(entry)
    subject_match = Subject.where("lower(unaccent(name)) = lower(unaccent(?))", entry.name)
    subject_match = subject_match.select { |subject| subject.credits == entry.credits.to_i }
    active_subjects = subject_match.select { |subject| !subject.inactive? }
    if subject_match.length == 1
      save_subject(subject_match.first)
    elsif active_subjects.length == 1
      save_subject(active_subjects.first)
    else
      @failed_entries << entry
    end
  end

  def save_subject(subject)
    current_student.force_add_subject(subject)
    @successful_entries << subject
  end
end

class TranscriptsController < ApplicationController
  def new
  end

  def create
    file = params.require(:file)
    @failed_entries = []
    @successful_entries = []

    Transcript::PdfProcessor.new(file).each do |entry|
      save_academic_entry(entry) if entry.approved?
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

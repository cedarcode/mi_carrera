require 'pdf-reader'

class AcademicHistoriesController < ApplicationController
  AcademicEntry = Struct.new(:name, :credits, :number_of_failures, :date_of_completion, :grade) do
    def approved?
      grade != '***'
    end
  end

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
      @academic_entries = academic_entries(file)
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
    current_student.force_add(subject)
    @successful_entries << subject
  end

  def academic_entries(file)
    reader = PDF::Reader.new(file.path)
    academic_entries = []

    reader.pages.each do |page|
      page.text.split("\n").each do |line|
        line.match(subject_regex) do |match|
          academic_entries << AcademicEntry.new(match[1], match[2], match[3], match[4], match[5])
        end
      end
    end

    academic_entries
  end

  # SubjectName Credits NumberOfFailures DateOfCompletion Grade
  def subject_regex
    /\s*(.*?)\s+(\d+)\s+(\d+)\s+(#{date_regex.source})\s+(#{grade_regex.source})/
  end

  # The date can be either a date in the format DD/MM/YYYY or **********
  def date_regex
    /\*{10}|\d\d\/\d\d\/\d\d\d\d/
  end

  # The grade can be either a number from 0 to 12, S/N or ***
  def grade_regex
    /\d+|S\/N|\*{3}/
  end
end

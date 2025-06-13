class TranscriptsController < ApplicationController
  def new
  end

  def create
    file = params.require(:file)
    @failed_entries = []
    @successful_subjects = []

    Transcript::PdfParser.new(file).each do |entry|
      next unless entry.approved?

      subject = entry.save_to_user(current_student)

      if subject
        @successful_subjects << subject
      else
        @failed_entries << entry
      end
    end
  end
end

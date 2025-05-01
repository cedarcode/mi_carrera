require 'pdf-reader'
require_relative 'academic_entry'

module Transcript
  class PdfParser
    include Enumerable

    def initialize(file)
      @reader = PDF::Reader.new(file.path)
    end

    def each
      reader.pages.each do |page|
        page.text.each_line do |line|
          line.match(subject_regex) do |match|
            yield AcademicEntry.new(
              name: match[1],
              credits: match[2].to_i,
              number_of_failures: match[3].to_i,
              date_of_completion: match[4],
              grade: match[5]
            )
          end
        end
      end
    end

    # SubjectName Credits NumberOfFailures DateOfCompletion Concept
    def subject_regex
      /\s*(.*?)\s+(\d+)\s+(\d+)\s+(#{date_regex.source})\s+(#{concept_regex.source})/
    end

    # The date can be either a date in the format DD/MM/YYYY or **********
    def date_regex
      /\*{10}|\d{2}\/\d{2}\/\d{4}/
    end

    # The concept can be either a string from the following list:
    # Aceptable, Bueno, Muy Bueno, Excelente, S/C or ***
    def concept_regex
      /Aceptable|Bueno|Muy Bueno|Excelente|S\/C|\*{3}/
    end

    private

    attr_reader :reader
  end
end

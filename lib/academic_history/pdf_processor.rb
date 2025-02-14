require 'pdf-reader'

module AcademicHistory
  class PdfProcessor
    include Enumerable

    AcademicEntry = Struct.new(:name, :credits, :number_of_failures, :date_of_completion, :grade) do
      def approved?
        grade != '***'
      end
    end

    def initialize(file)
      @reader = PDF::Reader.new(file.path)
    end

    def each(&block)
      reader.pages.each do |page|
        page.text.split("\n").each do |line|
          line.match(subject_regex) do |match|
            block.call(AcademicEntry.new(match[1], match[2], match[3], match[4], match[5]))
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
      /\*{10}|\d\d\/\d\d\/\d\d\d\d/
    end

    # The concept can be either a number from 0 to 12, S/N or ***
    def concept_regex
      /Aceptable|Bueno|Muy Bueno|Excelente|S\/C|\*{3}/
    end

    private

    attr_reader :reader
  end
end

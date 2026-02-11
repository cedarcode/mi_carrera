module Transcript
  class AcademicEntry
    attr_accessor :name, :credits, :number_of_failures, :date_of_completion, :grade

    def initialize(name: nil, credits: nil, number_of_failures: nil, date_of_completion: nil, grade: nil)
      @name = name
      @credits = credits
      @number_of_failures = number_of_failures
      @date_of_completion = date_of_completion
      @grade = grade
    end

    def approved?
      grade != '***'
    end

    def save_to_user(student)
      subject = subject_from_name(name, student.degree_id)

      return false if subject.blank?

      student.force_add_subject(subject)
      subject
    end

    private

    def subject_from_name(name, degree_id)
      subject_match = Subject.where("lower(unaccent(name)) = lower(unaccent(?))", name)
      subject_match = subject_match.select { |subject| subject.credits == credits.to_i }
      subject_match = subject_match.select { |subject| subject.degree_id == degree_id }

      return subject_match.first if subject_match.length == 1

      active_subjects = subject_match.select { |subject| !subject.inactive? }

      active_subjects.first if active_subjects.length == 1
    end
  end
end

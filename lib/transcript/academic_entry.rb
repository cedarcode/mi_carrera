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

    def save_to_user(user)
      subject_match = Subject.where("lower(unaccent(name)) = lower(unaccent(?))", name)
      subject_match = subject_match.select { |subject| subject.credits == credits.to_i }
      active_subjects = subject_match.select { |subject| !subject.inactive? }
      if subject_match.length == 1
        user.force_add_subject(subject_match.first)
        return subject_match.first
      elsif active_subjects.length == 1
        user.force_add_subject(active_subjects.first)
        return active_subjects.first
      end
    end
  end
end

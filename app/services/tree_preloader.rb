class TreePreloader
  def initialize(subjects)
    @subjects = subjects
  end

  def preload
    subjects.to_a.each do |subject|
      preloaded_subject = find_preloaded_subject(subject.id)
      subject.association(:course).target = preloaded_subject.course
      subject.association(:exam).target = preloaded_subject.exam
    end
  end

  private

  attr_reader :subjects

  def find_preloaded_subject(id)
    return PreloadedSubjects.data[id] if PreloadedSubjects.data.key?(id)

    PreloadedSubjects.reload!
    PreloadedSubjects.data[id]
  end
end

class TreePreloader
  def initialize(subjects)
    @subjects = subjects
  end

  def preload
    subjects.to_a.each do |subject|
      preloaded_approvables = find_preloaded_approvables(subject.id)
      subject.association(:course).target = preloaded_approvables[:course]
      subject.association(:exam).target = preloaded_approvables[:exam]
    end
  end

  private

  attr_reader :subjects

  def find_preloaded_approvables(id)
    return PreloadedApprovablesFetcher.data[id] if PreloadedApprovablesFetcher.data.key?(id)

    PreloadedApprovablesFetcher.reload!
    PreloadedApprovablesFetcher.data[id]
  end
end

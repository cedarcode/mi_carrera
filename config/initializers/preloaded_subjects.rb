module PreloadedSubjects
  mattr_accessor :_data

  def self.data
    self._data ||= PreloadedSubjectsFetcher.call
  end

  def self.reload!
    self._data = PreloadedSubjectsFetcher.call
  end
end

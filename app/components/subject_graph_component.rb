class SubjectGraphComponent < ViewComponent::Base
  def initialize(subjects:, current_student:, semester_map: nil)
    @subjects = subjects
    @current_student = current_student
    @semester_map = semester_map
  end

  def nodes
    @subjects.map do |subject|
      {
        id: subject.id,
        code: subject.code,
        name: subject.short_name || subject.name,
        url: helpers.subject_path(subject),
        available: @current_student.available?(subject),
        completed: @current_student.approved?(subject),
        semester: semester_for(subject)
      }
    end
  end

  def edges
    subject_ids = Set.new(@subjects.map(&:id))
    edges = []

    @subjects.each do |subject|
      collect_prerequisite_edges(subject.course&.prerequisite_tree, subject.id, subject_ids, edges)
    end

    edges.uniq
  end

  def semester_labels
    semesters = @subjects.map { |s| semester_for(s) }.uniq.sort

    semesters.index_with do |sem|
      semester_display_label(sem)
    end
  end

  private

  def semester_for(subject)
    if @semester_map
      @semester_map[subject.id] || 0
    else
      index = Subject::CATEGORIES.index(subject.category&.to_sym)
      index ? index + 1 : 0
    end
  end

  def semester_display_label(semester)
    return "Otras" if semester == 0

    if @semester_map
      "Semestre #{semester}"
    else
      category = Subject::CATEGORIES[semester - 1]
      category ? helpers.formatted_category(category.to_s) : "Semestre #{semester}"
    end
  end

  def collect_prerequisite_edges(prerequisite, target_subject_id, subject_ids, edges)
    return unless prerequisite

    case prerequisite
    when SubjectPrerequisite
      source_subject_id = prerequisite.approvable_needed.subject_id
      if subject_ids.include?(source_subject_id)
        edges << { source: source_subject_id, target: target_subject_id }
      end
    when LogicalPrerequisite
      # Skip "not" operators - they represent inverse relationships
      return if prerequisite.logical_operator == "not"

      prerequisite.operands_prerequisites.each do |child|
        collect_prerequisite_edges(child, target_subject_id, subject_ids, edges)
      end
    end
  end
end

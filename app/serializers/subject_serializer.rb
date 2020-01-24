class SubjectSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :name, :path, :course_approved, :has_exam, :can_enroll_to_exam, :exam_approved


  def path
    subject_path(object)
  end

  def course_approved
    bedel.approved?(object.course)
  end

  def has_exam
    !!object.exam
  end

  def can_enroll_to_exam
    has_exam && bedel.able_to_do?(object.exam)
  end

  def exam_approved
    bedel.approved?(object.exam)
  end

  private

  def bedel
    scope.bedel
  end
end

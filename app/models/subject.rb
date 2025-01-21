class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  belongs_to :group, class_name: 'SubjectGroup', optional: true
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :credits, presence: true
  validates :code, uniqueness: true

  scope :with_exam, -> { includes(:exam, :course).where.not(exam: { id: nil }) }
  scope :without_exam, -> { includes(:exam, :course).where(exam: { id: nil }) }

  CATEGORIES = %i[
    first_semester
    second_semester
    third_semester
    fourth_semester
    fifth_semester
    sixth_semester
    seventh_semester
    eighth_semester
    nineth_semester
    optional
    extension_module
    outside_montevideo
    inactive
    revalid
  ]

  enum :category, CATEGORIES.index_with(&:to_s)

  scope :ordered_by_category, -> { in_order_of(:category, CATEGORIES) }
  scope :ordered_by_category_and_name, -> { ordered_by_category.order(:name) }
  scope :current_semester_optionals, -> { where(current_optional_subject: true) }

  def self.approved_credits(approved_approvable_ids)
    without_exam.where(course: { id: approved_approvable_ids }).or(
      with_exam.where(exam: { id: approved_approvable_ids })
    ).sum(:credits)
  end

  def approved?(approved_approvable_ids)
    approved_approvable_ids.include?(exam ? exam.id : course.id)
  end

  def hidden_by_default?
    revalid? || inactive? || outside_montevideo? || extension_module?
  end

  def average_rating
    reviews.average(:rating).to_f.round(1) if reviews.any?
  end

  delegate :available?, to: :course
end

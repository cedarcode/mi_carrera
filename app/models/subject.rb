class Subject < ApplicationRecord
  belongs_to :degree
  has_one :course, -> { where is_exam: false }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  has_one :exam, -> { where is_exam: true }, class_name: 'Approvable', dependent: :destroy, inverse_of: :subject
  belongs_to :group, class_name: 'SubjectGroup', optional: true
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :credits, presence: true
  validates :code, uniqueness: { scope: :degree_id }

  scope :with_exam, -> { includes(:exam, :course).where.not(exam: { id: nil }) }
  scope :without_exam, -> { includes(:exam, :course).where(exam: { id: nil }) }
  scope :search, ->(term) {
    where("lower(unaccent(subjects.name)) LIKE lower(unaccent(?))", "%#{term.strip}%")
      .or(where("lower(unaccent(short_name)) LIKE lower(unaccent(?))", "%#{term.strip}%"))
      .or(where("lower(code) LIKE lower(?)", "%#{term.strip}%"))
  }

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
    tenth_semester
    optional
    extension_module
    outside_montevideo
    inactive
    revalid
  ]

  enum :category, CATEGORIES.index_with(&:to_s)

  scope :ordered_by_category, -> { in_order_of(:category, CATEGORIES) }
  scope :ordered_by_short_or_full_name, -> { order(Arel.sql('unaccent(COALESCE(short_name, name))')) }
  scope :ordered_by_category_and_name, -> { ordered_by_category.order(:name) }
  scope :current_semester_optionals, -> { where(current_optional_subject: true) }
  scope :approved_for, ->(approved_approvable_ids) {
    without_exam.where(course: { id: approved_approvable_ids }).or(
      with_exam.where(exam: { id: approved_approvable_ids })
    )
  }
  scope :active, -> { where.not(category: 'inactive') }
  scope :active_or_approved, ->(approved_ids) {
    approved_for(approved_ids).or(active)
  }

  def self.approved_credits(approved_approvable_ids)
    approved_for(approved_approvable_ids).sum(:credits)
  end

  def approved?(approved_approvable_ids)
    approved_approvable_ids.include?(exam ? exam.id : course.id)
  end

  def hidden_by_default?
    revalid? || inactive? || outside_montevideo? || extension_module?
  end

  def average_interesting_rating
    reviews.average(:interesting_rating)&.round(1)
  end

  def average_credits_to_difficulty_rating
    reviews.average(:credits_to_difficulty_rating)&.round(1)
  end

  delegate :available?, to: :course
end

# == Schema Information
#
# Table name: subjects
#
#  id                       :bigint           not null, primary key
#  category                 :string           default("optional")
#  code                     :string
#  credits                  :integer          not null
#  current_optional_subject :boolean          default(FALSE)
#  name                     :string           not null
#  short_name               :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  degree_id                :string           not null
#  eva_id                   :string
#  group_id                 :integer
#  openfing_id              :string
#  second_semester_eva_id   :string
#
# Indexes
#
#  index_subjects_on_degree_id           (degree_id)
#  index_subjects_on_degree_id_and_code  (degree_id,code) UNIQUE
#  index_subjects_on_group_id            (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (degree_id => degrees.id)
#  fk_rails_...  (group_id => subject_groups.id)
#

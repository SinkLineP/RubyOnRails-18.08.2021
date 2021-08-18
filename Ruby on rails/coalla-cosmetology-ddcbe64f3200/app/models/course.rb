# == Schema Information
#
# Table name: courses
#
#  id                       :integer          not null, primary key
#  name                     :text             not null
#  active                   :boolean          default(FALSE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  syllabus                 :text
#  delta                    :boolean          default(TRUE), not null
#  timetable                :text
#  price                    :integer
#  external_url             :text
#  short_name               :text
#  hours                    :integer          default(0), not null
#  faculty_id               :integer
#  remote_price             :integer          default(0), not null
#  appointment              :text             not null
#  cost                     :integer          default(0)
#  slug                     :string
#  title                    :string
#  image                    :text
#  announcement             :text
#  practice_hours           :float            default(0.0), not null
#  price_per_month          :float            default(0.0), not null
#  total_price              :float            default(0.0), not null
#  limitation               :string
#  video                    :text
#  early_booking            :boolean          default(FALSE), not null
#  economy                  :float            default(0.0), not null
#  job                      :string
#  profit                   :float            default(0.0), not null
#  small_image              :text
#  special_offer            :boolean          default(FALSE), not null
#  nearest_group_id         :integer
#  nearest_education_day    :date
#  education_period         :integer          default(6), not null
#  subject                  :text
#  medical_education        :boolean          default(FALSE), not null
#  work_in_cosmetology      :boolean          default(FALSE), not null
#  tag_title                :text
#  tag_description          :text
#  badge                    :text
#  diplom_title             :text
#  status_notification_name :text             default("other_notification"), not null
#  place_over_notification  :boolean          default(FALSE), not null
#  with_amo_module          :boolean          default(FALSE), not null
#  shop_id                  :integer
#  default_course           :boolean          default(FALSE), not null
#  notification_audio       :text
#  ivr_audio                :text
#  economy_for_several      :float
#  economy_description      :text
#  course_counts            :integer          default(0), not null
#  additional_amo_module_id :integer
#  student_docs_required    :boolean          default(TRUE), not null
#
# Indexes
#
#  index_courses_on_active                    (active)
#  index_courses_on_additional_amo_module_id  (additional_amo_module_id)
#  index_courses_on_faculty_id                (faculty_id)
#  index_courses_on_name                      (name)
#  index_courses_on_nearest_group_id          (nearest_group_id)
#  index_courses_on_shop_id                   (shop_id)
#

class Course < ActiveRecord::Base
  extend Enumerize
  include WithUploadedVideo
  include WithFriendly

  mattr_accessor :long_course_hours
  @@long_course_hours = 100

  alias_attribute :search_content, :name

  delegate :title, to: :faculty, allow_nil: true, prefix: true

  mount_uploader :syllabus, FileUploader
  mount_uploader :image, CourseImageUploader
  mount_uploader :small_image, CourseSmallImageUploader
  mount_uploader :notification_audio, AudioUploader
  mount_uploader :ivr_audio, AudioUploader

  with_uploaded_video

  enumerize :appointment,
            in: [:retraining,
                 :advanced_training,
                 :additional_education,
                 :traineeship],
            default: :additional_education

  serialize :subject, Array
  enumerize :subject,
            in: [:face_care,
                 :body_care,
                 :injections,
                 :instrumental_cosmetology],
            multiple: true

  enumerize :status_notification_name,
            in: [:other_notification,
                 :skdi_notification,
                 :sk_notification,
                 :ke_notification,
                 :ks_notification],
            default: :other_notification

  belongs_to :shop
  belongs_to :faculty, inverse_of: :courses
  belongs_to :nearest_group, class_name: :Group, foreign_key: :nearest_group_id
  belongs_to :additional_amo_module, class_name: 'AmoModule'
  has_many :consultations, inverse_of: :course, dependent: :nullify
  has_many :course_blocks, -> { order(:position) }, inverse_of: :course, dependent: :destroy
  has_many :blocks, through: :course_blocks
  has_many :lectures, ->() { where(blocks: { active: true }).unscope(:order).order('course_blocks.position, lectures.position') }, through: :blocks
  has_many :tasks, through: :lectures
  has_many :results, through: :tasks
  has_many :groups, inverse_of: :course, dependent: :destroy
  has_many :students, through: :groups
  has_many :subscriptions, through: :groups
  has_many :course_documents, inverse_of: :course, dependent: :destroy
  has_many :course_links, inverse_of: :course, dependent: :destroy
  has_many :course_works, -> { ordered }, inverse_of: :course, dependent: :destroy
  has_many :works, through: :course_works
  has_many :course_specialities, -> { order(:position) }, inverse_of: :course, dependent: :destroy
  has_many :specialities, through: :course_specialities
  has_many :course_curriculum_blocks, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_many :curriculum_blocks, through: :course_curriculum_blocks
  has_many :course_recalls, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_many :recalls, through: :course_recalls
  has_many :course_advantages, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_many :advantages, through: :course_advantages
  has_many :course_skills, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_many :skills, through: :course_skills
  has_many :course_education_documents, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_many :education_documents, through: :course_education_documents
  has_many :pictures, through: :education_documents
  has_many :course_instructors, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_many :instructors, through: :course_instructors
  has_many :similar_courses, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_many :other_similar_courses, dependent: :destroy, inverse_of: :course, class_name: :SimilarCourse, foreign_key: :similar_id
  has_many :similars, through: :similar_courses
  has_many :course_promo_codes, inverse_of: :course, dependent: :destroy
  has_many :course_automatic_discounts, inverse_of: :course, dependent: :destroy
  has_many :amo_module_courses, -> { order(:position) }, inverse_of: :course, dependent: :destroy
  has_many :subscription_documents, dependent: :destroy, inverse_of: :course
  has_many :blog_courses, dependent: :destroy, inverse_of: :course
  has_many :module_groups, dependent: :destroy, inverse_of: :course
  has_many :course_seos, autosave: true, dependent: :destroy, inverse_of: :course

  accepts_nested_attributes_for :course_documents, allow_destroy: true
  accepts_nested_attributes_for :course_works, allow_destroy: true
  accepts_nested_attributes_for :course_seos, allow_destroy: true, reject_if: proc { |attributes| attributes["position"].blank? }, limit: 3

  validates :name, presence: true
  validates :slug, uniqueness: true, allow_blank: true
  validates :price, :remote_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :practice_hours, :price_per_month, :total_price, :economy, :profit, presence: true

  before_validation :set_default_values
  before_save :set_timetable_link
  before_save :set_slug

  scope :active, -> { where(active: true) }
  scope :with_specialities, -> { joins(:specialities) }
  scope :alphabetical_order, -> { order(:name) }
  scope :alphabetical_order_display_name, -> { order("COALESCE(NULLIF(short_name, ''), name)") }
  scope :ordered, -> { order(:name) }
  scope :long_courses, -> { where('courses.hours >= ?', long_course_hours) }
  scope :short_courses, -> { where('courses.hours < ?', long_course_hours) }
  scope :displayed, -> { active.where.not(nearest_group_id: nil).where('nearest_education_day > ?', Date.current).order(:nearest_education_day) }
  scope :special_offers, -> { where(special_offer: true) }
  scope :default_courses, -> { where(default_course: true) }

  def friendly
    slug.presence || id.presence
  end

  def long?
    hours.to_i >= Course.long_course_hours
  end

  def short?
    hours.to_i < Course.long_course_hours
  end

  def links
    course_links.map(&:link)
  end

  def unlinked?
    groups.blank? && results.blank?
  end

  def display_name
    short_name.presence || name.to_s.truncate(50, omission: '')
  end

  def tag_name
    short_name.presence || name.to_s
  end

  def active_blocks
    blocks.where(active: true)
  end

  def time
    @hours ||= (lectures.sum(:time) || 0)
  end

  def total_hours
    time
  end

  def expected_days
    @expected_days ||= (lectures.sum(:term) || 0)
  end

  def total_tasks
    lectures_count
  end

  def block_position(block)
    (blocks.find_index(block) || 0) + 1
  end

  def lecture_position(lecture)
    (lectures.find_index(lecture) || 0) + 1
  end

  def lectures_count
    @lectures_count ||= lectures.count
  end

  def active_students
    students.select { |student| student.course_status(self) == :active }.group_by { |s| s.group_for_course(self) }
  end

  def graduates
    students.select { |student| student.course_status(self) == :passed }.group_by { |s| s.group_for_course(self) }
  end

  def grouped_documents
    course_documents.group_by(&:education_level)
  end

  def student_course_document(student, document)
    course_documents.find_by(education_level: student.education_level, education_document_id: document.education_document_id)
  end

  def name_for_document(student, document)
    document = student_course_document(student, document)
    document.try(:program_name).presence || name
  end

  def diploma_title_for_document(student, document)
    document = student_course_document(student, document)
    document.try(:diploma_title)
  end

  def academic_hours_for_document(student, document)
    document = student_course_document(student, document)
    document.try(:academic_hours) || hours
  end

  # for correct ordering
  # TODO (vl): refactor this
  [
    :block,
    :speciality,
    :curriculum_block,
    :recall,
    :skill,
    :advantage,
    :education_document,
    :instructor,
  ].each do |field_name|
    define_method "#{field_name}_ids=" do |item_ids|
      item_ids = item_ids || []
      item_ids.each_with_index do |id, index|
        send("course_#{field_name.to_s.pluralize}").find_by("#{field_name}_id" => id).try(:update_column, :position, index + 1)
      end
      update_columns(delta: true) unless new_record?
      super(item_ids)
    end
  end

  # for correct ordering
  # TODO (vl): refactor this
  def similar_ids=(similar_ids = [])
    similar_ids.each_with_index do |id, index|
      similar_courses.find_by(similar_id: id).try(:update_column, :position, index + 1)
    end
    super
  end

  def nearest_groups
    @nearest_groups ||= groups
                          .with_free_places
                          .select { |group| group.nearest_education_day > Date.current }
                          .sort_by(&:nearest_education_day)
  end

  def find_nearest_group(group_id)
    return if group_id.blank?
    nearest_groups.detect { |g| g.id == group_id.to_i }
  end

  def reset_nearest_group
    update_columns(nearest_group_id: nil,
                   nearest_education_day: nil,
                   delta: true)
  end

  def change_nearest_group
    group = nearest_groups.first
    update_columns(nearest_group_id: group.try(:id),
                   nearest_education_day: group.try(:nearest_education_day),
                   delta: true)
  end

  def root_speciality
    first_sub_speciality.try(:parent)
  end

  def first_sub_speciality
    specialities.first
  end

  def displayed?
    active? && nearest_group_id.present? && nearest_education_day > Date.current
  end

  def groups_has_early_booking?
    groups.detect { |g| g.early_booking? }.present?
  end

  private

  def set_default_values
    self.price ||= 0
    self.remote_price ||= 0
    self.hours ||= 0
  end

  def set_slug
    self.slug = title.parameterize if slug.blank? && title.present?
  end

  def set_timetable_link
    self.timetable = "http://#{timetable}" if timetable.present? && !timetable.start_with?('http')
  end
end

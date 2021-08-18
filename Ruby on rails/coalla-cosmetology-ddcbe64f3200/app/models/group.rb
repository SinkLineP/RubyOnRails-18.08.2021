# == Schema Information
#
# Table name: groups
#
#  id                        :integer          not null, primary key
#  title                     :text
#  course_id                 :integer
#  instructor_id             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  begin_on                  :date             not null
#  end_on                    :date             not null
#  distances_place           :integer          default(0), not null
#  distances_count           :integer          default(0), not null
#  academics_place           :integer          default(0), not null
#  academics_count           :integer          default(0), not null
#  start_time                :time             default("2000-01-01T09:00:00.000Z"), not null
#  end_time                  :time             default("2000-01-01T13:00:00.000Z"), not null
#  academic_on               :date
#  schedule_type             :text             default("specific_days"), not null
#  shift_work_on             :datetime
#  schedule_description      :text
#  week_days                 :text
#  deleted_at                :datetime
#  active                    :boolean          default(FALSE), not null
#  itec                      :datetime
#  fake                      :boolean          default(FALSE)
#  places_over_notified      :boolean          default(FALSE), not null
#  shop_id                   :integer
#  scheduled                 :boolean          default(FALSE), not null
#  webinar_link              :text
#  webinar_notification_sent :boolean          default(FALSE), not null
#  practice_address          :string
#
# Indexes
#
#  index_groups_on_course_id      (course_id)
#  index_groups_on_instructor_id  (instructor_id)
#  index_groups_on_shop_id        (shop_id)
#

class Group < ActiveRecord::Base
  extend Enumerize
  include TimeFields
  include GroupExtensions
  include GroupPlacesExtensions

  belongs_to :course, inverse_of: :groups
  belongs_to :instructor, inverse_of: :groups
  has_many :prices, inverse_of: :group, class_name: :GroupPrice, dependent: :destroy
  has_many :subscriptions, inverse_of: :group, class_name: :GroupSubscription, dependent: :destroy
  has_many :students, through: :subscriptions
  has_many :actual_students, -> { merge(GroupSubscription.actual.not_created_from_module) }, through: :subscriptions, source: :student
  has_many :amo_success_students, -> { merge(GroupSubscription.actual) }, through: :subscriptions, source: :student
  has_many :active_students, -> { merge(GroupSubscription.active) }, through: :subscriptions, source: :student
  has_many :active_students_not_module_subscription, -> { merge(GroupSubscription.active.not_created_from_module) }, through: :subscriptions, source: :student
  has_many :notice_groups, inverse_of: :group, dependent: :destroy
  has_many :notices, through: :notice_groups
  has_many :practices, -> { order(:begin_on, :start_time) }, inverse_of: :group, dependent: :destroy
  has_one :addition_order, as: :item
  has_many :work_results, inverse_of: :group, dependent: :destroy
  has_many :payment_logs, dependent: :nullify, inverse_of: :group
  has_many :expulsions, -> { order(:created_at) }, inverse_of: :group, dependent: :destroy
  has_many :expelled_students, through: :expulsions
  has_many :generated_documents, as: :item, dependent: :destroy
  has_many :subscription_documents, through: :subscriptions
  has_many :education_documents, through: :subscription_documents
  has_many :final_work_registries, as: :item
  has_many :attendance_logs, as: :item
  has_many :group_lists, as: :item
  has_many :document_copies, as: :item
  has_many :module_groups, inverse_of: :group_subscription, dependent: :destroy
  has_many :schedule_item_groups, dependent: :destroy, inverse_of: :group

  accepts_nested_attributes_for :addition_order
  accepts_nested_attributes_for :document_copies, allow_destroy: true

  acts_as_paranoid

  amoeba { enable }

  enumerize :schedule_type, in: %i(specific_days shift_work), default: :specific_days, predicates: true

  serialize :week_days, Array
  enumerize :week_days, in: %i(monday tuesday wednesday thursday friday saturday sunday), multiple: true

  delegate :timetable, :name, :hours, :remote_price, to: :course, allow_nil: true, prefix: true
  delegate :reset_nearest_group, :change_nearest_group, to: :course, prefix: true

  alias_attribute :name, :title

  formatted_time_field :start_time, :end_time

  with_options(presence: true) do
    validates :title, uniqueness: true
    validates :course_id
    validates :begin_on
    validates :end_on
    validates :start_time
    validates :end_time
    validates :shift_work_on, if: Proc.new { |group| group.schedule_type.shift_work? }
  end

  with_options(numericality: { greater_than_or_equal_to: 0 }) do
    validates :distances_place
    validates :distances_count
    validates :academics_place
    validates :academics_count
  end

  scope :ordered, ->() { order(:created_at) }
  scope :ordered_by_title, ->() { order(:title) }
  scope :ordered_by_course_name, ->() { includes(:course).order('courses.name, groups.created_at') }
  scope :ascending_name, ->() { order(:name) }
  scope :ascending_begin_on, ->() { order(:begin_on) }
  scope :for_instructor, ->(instructor) { where('instructor_id IS NULL OR instructor_id = ?', instructor.id) }
  scope :active, ->() { where(active: true) }
  scope :with_long_courses, ->() { joins(:course).merge(Course.long_courses) }
  scope :with_short_courses, ->() { joins(:course).merge(Course.short_courses) }
  scope :with_practice, ->(date) { joins(:practices).where(practices: { begin_on: date }) }
  scope :actual, -> { where("end_on + INTERVAL '6 month' >= ?", Date.current) }
  scope :finished, -> { where("end_on > ?", Date.current) }
  scope :with_free_places, -> { active.where('(academics_place > academics_count) OR (distances_place > distances_count)').preload(:practices) }
  scope :without_free_places, -> { active.where('distances_place <= distances_count').preload(:practices) }
  scope :not_notified, -> { where(places_over_notified: false) }

  with_options(reject_if: :all_blank, allow_destroy: true) do
    accepts_nested_attributes_for :practices
    accepts_nested_attributes_for :prices
  end

  accepts_nested_attributes_for :expulsions, allow_destroy: true, reject_if: ->(attributes) { attributes[:expelled_students_attributes].blank? }

  before_validation do
    self.title = generate_title if title.blank?
  end

  after_save :course_change_nearest_group
  before_destroy :course_reset_nearest_group
  after_destroy :course_change_nearest_group

  def self.ransackable_scopes(auth_object = nil)
    [:year]
  end

  def self.group_select_scope(group, course_id = nil)
    scope = group ? [group] : []
    query = active.ordered_by_course_name
    query = query.where(course_id: course_id) if course_id
    scope += query.to_a
    scope.uniq.map { |g| [g.title, g.id] }
  end

  def self.year(value)
    where('to_char(begin_on, \'YYYY\') = ?', value)
  end

  def end_date_time
    DateTime.new(end_on.year, end_on.month, end_on.day, end_time.hour, end_time.min)
  end

  def appropriate_education_documents
    subscription_ids = subscriptions.actual.not_expelled.map(&:id)
    education_documents.joins(subscription_documents: :group_subscription).where(group_subscriptions: { id: subscription_ids }).uniq
  end

  def students_count
    distances_count + academics_count
  end

  def save_and_generate_documents!
    transaction do
      save!
      (addition_order || build_addition_order).generate!
    end
  end

  def save_and_generate_registries!(options = {})
    transaction do
      save!
      self.final_work_registries.destroy_all
      creation_date = Time.now
      appropriate_education_documents.each do |document|
        options[:code] = document.code
        if subscriptions.actual.not_expelled.joins(:education_documents, :student)
             .where(education_documents: { code: document.code }).uniq.any?
          options[:document_name] = "Реестр (#{document.title})"
          self.final_work_registries.build(created_on: creation_date).generate!(options)
        end
      end
    end
  end

  def save_and_generate_attendances!(options = {})
    transaction do
      save!
      self.attendance_logs.destroy_all
      range_dates = practices_range_dates
      if range_dates[:begin] && range_dates[:end]
        range_dates[:begin].each_month(range_dates[:end].end_of_month) do |dt|
          year_number, month_number = dt.year, dt.month
          practices_in_month = practices_count_in_month(Date.new(year_number, month_number, 1))
          next if practices_in_month == 0
          options[:year_number] = year_number
          options[:month_number] = month_number
          options[:practices_count] = practices_in_month
          options[:document_name] = "Журнал посещаемости (#{Russian.strftime(Date.new(2001, month_number, 1), '%B')})"
          self.attendance_logs.build.generate!(options)
        end
      end
    end
  end

  def save_and_generate_group_lists!(options = {})
    transaction do
      save!
      self.group_lists.destroy_all
      self.group_lists.build.generate!(options)
    end
  end

  def generate_title
    return '' unless course
    # КЭ-16-9-КЭ-5/2-Ф
    [
      course.try(:short_name),
      localize_for(begin_on, '%y').try(:gsub, /^0/, ''),
      localize_for(start_time, '%H').try(:gsub, /^0/, ''),
      course.try(:short_name),
      schedule_type.shift_work? ? '2/2' : "#{week_days.size}/#{7 - week_days.size}",
      localize_for(begin_on, '%m'),
    ].compact.join('-')
  end

  def recalculate_counters
    distances_count = subscriptions.active.not_academic_vacation.where(education_form: EducationForm.online).count
    academics_count = subscriptions.active.not_academic_vacation.where(education_form: EducationForm.offline).count
    update_columns(distances_count: distances_count, academics_count: academics_count)
    course_change_nearest_group
  end

  def nearest_education_day
    first_practice_day || begin_on
  end

  def last_education_day
    last_practice_day || end_on
  end

  def education_times
    if practices.blank?
      times = [start_time, end_time]
    else
      times = [practices.first.try(:start_time), practices.first.try(:end_time)].reject(&:blank?)
    end

    times = times.reject { |t| t.seconds_since_midnight == 0 }

    times.uniq
  end

  def education_dates
    dates = [practices.first.try(:begin_on), practices.last.try(:end_on)].reject(&:blank?)
    dates = [begin_on, end_on] if dates.blank?
    dates.uniq
  end

  def last_practice_day
    practices.last.try(:end_on)
  end

  def first_practice_day
    practices.first.try(:begin_on)
  end

  def first_practice_after_days?(count, between = false)
    if between
      current_date, future_date = Date.current, (Date.current + count.days)
      first_practice_day.try(:between?, current_date, future_date)
    else
      first_practice_day == (Date.current + count.days)
    end
  end

  def early_booking?
    course.early_booking? && nearest_education_day > (Time.current + 3.month)
  end

  def education_form
    academics_free_place > 0 ? EducationForm.offline : EducationForm.online
  end

  def practices_range_dates
    practices_range = practices.first(2)
    { begin: practices_range.reject(&:blank?).min_by(&:begin_on).try(:begin_on),
      end: practices_range.reject(&:blank?).max_by(&:date_of_end).try(:date_of_end) }
  end

  def practices_time_text
    practices.first(2).reject(&:blank?).map { |p| "#{p.start_time.strftime('%H:%M')} - #{p.end_time.strftime('%H:%M')}" }.join(', ')
  end

  def practices_count_in_month(date)
    result = 0
    date_range = date.beginning_of_month..date.end_of_month
    practices.first(2).each do |item_practice|
      practice_range = item_practice.begin_on..(item_practice.end_on || item_practice.begin_on)
      result += 1 if date_range.overlaps?(practice_range)
    end
    result
  end

  def expel_student!(student)
    expulsion = expulsions.build(personal: false, expelled_on: Date.current)
    expulsion.expelled_students.build(student: student)
    expulsion.save
  end

  def correct_day?(day)
    return false unless day
    unless specific_days?
      return false if practices.blank?
      ranges = practices.map { |practice| practice.begin_on..practice.end_on }
      ranges << (practices.last.begin_on..day)
      range = ranges.detect { |range| range.include?(day) }
      range.each_slice(4).any? { |dates| dates[0..1].include?(day) }
    end

    if week_days.present?
      week_days.values.include?(day.strftime('%A').downcase)
    else
      true
    end
  end

  private

  def localize_for(datetime, format)
    I18n.l(datetime, format: format) if datetime
  end

end

# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  type                      :string
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :text
#  last_name                 :text
#  delta                     :boolean          default(TRUE), not null
#  avatar                    :text
#  demo                      :boolean          default(FALSE), not null
#  hide_tutorial             :boolean          default(FALSE), not null
#  encrypted_email_password  :text
#  middle_name               :text
#  birthday                  :date
#  translit_name             :text
#  phones                    :text             default([]), is an Array
#  emails                    :text             default([]), is an Array
#  education_level_id        :integer
#  passport_series           :text
#  passport_number           :text
#  passport_issued_on        :date
#  passport_organisation     :text
#  passport_address          :text
#  address                   :text
#  amocrm_id                 :text
#  imported_from_amo         :boolean          default(FALSE), not null
#  welcome_sent_at           :datetime
#  comagic_campaign          :text
#  update_job_id             :integer
#  wear_size                 :text
#  version                   :integer          default(0), not null
#  campaign_id               :integer
#  amo_created_at            :datetime
#  description               :text
#  subscribed_on_blog        :boolean          default(FALSE)
#  wordpress_id              :integer
#  phone_added_at            :datetime
#  deleted_at                :datetime
#  shop_id                   :integer
#  privacy_policy_confirmed  :boolean          default(FALSE), not null
#  notified_about_requisites :boolean          default(FALSE), not null
#  source                    :string           default("none"), not null
#
# Indexes
#
#  index_users_on_amocrm_id_and_email_and_emails_and_phones  (amocrm_id,email,emails,phones)
#  index_users_on_campaign_id                                (campaign_id)
#  index_users_on_education_level_id                         (education_level_id)
#  index_users_on_email                                      (email) UNIQUE
#  index_users_on_reset_password_token                       (reset_password_token) UNIQUE
#  index_users_on_shop_id                                    (shop_id)
#

class Student < User
  include Loggerable

  AMO_SYNC_FIELDS = %i(first_name last_name middle_name education_level_id)
  FAKE_EMAIL_POSTFIX = "@sikorsky.academy"

  attr_accessor :skip_sync_amo_data,
                :index,
                :end_on,
                :begin_on,
                :registration_number,
                :generation_date,
                :blank_number,
                :first_practice_date,
                :second_practice_date

  belongs_to :campaign, inverse_of: :students
  has_many :all_group_subscriptions, -> { with_deleted }, class_name: :GroupSubscription
  has_many :group_subscriptions, -> { order("group_subscriptions.end_on desc") }, inverse_of: :student
  has_many :available_subscriptions, -> { active.order("group_subscriptions.end_on desc") }, class_name: :GroupSubscription
  has_many :education_forms, through: :group_subscriptions
  has_many :groups, through: :group_subscriptions
  has_many :courses, through: :group_subscriptions
  has_many :finished_materials, inverse_of: :student, dependent: :destroy
  has_many :feedback_questions, inverse_of: :student, dependent: :destroy
  has_many :deleted_notices, inverse_of: :student, dependent: :destroy
  has_many :notices, through: :groups, dependent: :destroy
  has_many :letters, inverse_of: :student, dependent: :destroy
  has_many :personal_notices, inverse_of: :student, dependent: :destroy
  has_many :notes, -> { order(:noted_at) }, as: :notable, dependent: :destroy
  has_many :payment_logs, -> { ordered }, dependent: :destroy, inverse_of: :student
  has_many :expelled_students, dependent: :destroy, inverse_of: :student
  has_many :student_work_results, dependent: :destroy, inverse_of: :student
  has_many :comment_threads, -> { order(:created_at) }, as: :commentable, dependent: :destroy, class_name: :Comment
  has_many :generated_documents, through: :group_subscriptions
  has_many :orders_generated_documents, through: :orders, source: :generated_documents
  has_many :results, -> { order(:created_at) }, inverse_of: :student, dependent: :destroy
  has_many :user_activities, -> { order(last_tracked_at: :desc) }, foreign_key: :user_id, dependent: :destroy

  accepts_nested_attributes_for :group_subscriptions, allow_destroy: true
  accepts_nested_attributes_for :comment_threads, allow_destroy: true

  validates :last_name, presence: true

  before_save :init_defaults
  after_update :sync_amo_data, if: :sync_amo_data?
  after_update :send_mindbox_notification, if: :send_mindbox_notification?
  after_save :update_campaign
  before_save do
    self.deleted_at = nil if amocrm_id_changed?
  end

  scope :by_alphabet, -> { order(:last_name, :first_name, :middle_name) }
  scope :active, ->(flag = true) { flag ? joins(:group_subscriptions).merge(GroupSubscription.active).distinct : all }
  scope :academic_vacation, ->(flag = true) { flag ? joins(:group_subscriptions).merge(GroupSubscription.academic_vacation).distinct : all }

  class << self
    def course_id_eq(id)
      return all if id.blank?
      subscriptions = GroupSubscription.for_course(id).unscope(:order).pluck(:id).uniq
      includes(group_subscriptions: [:group, :module_courses]).references(:groups, :amo_modules).where(group_subscriptions: { id: subscriptions }).distinct
    end

    def deleted_eq(value)
      return all if value.nil? || value.try(:empty?)
      return where.not(deleted_at: nil) if value
      where(deleted_at: nil)
    end

    def amo_module_exists(value)
      return all if value.nil? || value.try(:empty?)
      return Student.joins(group_subscriptions: :amo_module).merge(GroupSubscription.actual).distinct if value
      courses_ids = Course.where(with_amo_module: true).pluck(:id)
      group_ids = Group.joins("LEFT OUTER JOIN practices ON practices.group_id = groups.id").where(course_id: courses_ids).where("practices.begin_on IS NULL OR practices.begin_on <= ?", Date.current).select(:id)
      student_ids = GroupSubscription.actual.not_expired.where(group_id: group_ids).select(:student_id)
      where(id: student_ids)
    end

    def amo_module_id_eq(id)
      return all if id.nil? || id.try(:empty?)
      joins(:group_subscriptions).where(group_subscriptions: { amo_module_id: id })
    end

    def subscriptions_created_by_user_eq(value)
      return all if value.nil? || value.try(:empty?)
      joins(:group_subscriptions).where(group_subscriptions: { created_by_user: value })
    end

    def ransackable_scopes(_auth_object = nil)
      %i(active academic_vacation course_id_eq deleted_eq amo_module_exists amo_module_id_eq subscriptions_created_by_user_eq)
    end
  end

  def available_courses
    @available_courses ||= available_subscriptions.map(&:course).select(&:active?).uniq
  end

  def all_courses
    @all_courses ||= all_group_subscriptions.map(&:course).select(&:active?).uniq
  end

  def student_work_results_for_course(course)
    @student_work_results_for_course ||= {}
    @student_work_results_for_course[course.id] ||= student_work_results.includes(:exercise_results, :work, work_result: :course).where(absent: false, courses: { id: course.id })
  end

  def student_work_results_for_group(group)
    @student_work_results_for_group ||= {}
    @student_work_results_for_group[group.id] ||= student_work_results.includes(:exercise_results, :work, :work_result).where(absent: false, work_results: { group_id: group.id })
  end

  def erase!
    transaction do
      all_group_subscriptions.each { |gs| gs.really_destroy! }
      destroy!
    end
  end

  def subscription_by_group(group_id)
    group_subscriptions.find_by(group_id: group_id)
  end

  def set_education_dates(group_id)
    subscription = group_subscriptions.find_by(group_id: group_id)
    self.begin_on = subscription.begin_on
    self.end_on = subscription.end_on
  end

  def set_document_params(group_id, code)
    subscription = group_subscriptions.find_by(group_id: group_id)
    document = subscription.subscription_documents.includes(:education_document).find_by(education_documents: { code: code })
    self.registration_number = document.try(:registration_number) || ""
    self.generation_date = document.try(:issued_at) || ""
    self.blank_number = document.try(:blank_number) || ""
  end

  def send_mindbox_notification?
    email_changed? && email_was.include?(FAKE_EMAIL_POSTFIX) && email.exclude?(FAKE_EMAIL_POSTFIX)
  end

  def send_mindbox_notification
    self.password = Devise.friendly_token(8)
    update_columns(encrypted_password: encrypted_password)
    Mindbox::XmlApiOperation.enqueue("FirstEmail",
                                     email: email,
                                     password: password)
  end

  def can_sign_in?
    available_subscriptions.any?
  end

  def welcome_sent?
    welcome_sent_at.present?
  end

  def has_lag_for_any_course?(courses)
    return false if courses.blank?
    courses.select { |c| available_courses.include?(c) }.any? { |course| lag_time_for_course(course) > 0 }
  end

  def lag_time_for_course(course)
    @lag_time_for_course ||= {}
    @lag_time_for_course[course.id] ||= Students::CourseTimeMarkers.new(self, course).lag_time_for_course
  end

  def user_activities_for_course(course, since = nil, to = nil)
    lecture_activities = user_activities.where(trackable: course.lectures)
    task_activities = user_activities.where(trackable: results_for_course(course))
    activities = (lecture_activities.to_a + task_activities.to_a)
    activities = activities.select { |a| a.last_tracked_at >= since } if since.present?
    activities = activities.select { |a| a.last_tracked_at <= to } if to.present?
    activities.sort_by(&:last_tracked_at).reverse
  end

  def results_for_course(course)
    results.where(task: course.tasks)
  end

  def mark_material_as_finished!(material)
    transaction do
      finished_materials.find_or_create_by!(material: material)
    end
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def material_finished?(material)
    finished_materials.find_by(material: material).present?
  end

  def course_status(course)
    subscription = any_group_subscription_for_course(course)
    return :unavailable if subscription.blank? || (subscription.inactive? && !subscription.expired?) || subscription.suspended?
    return :expired if subscription.expired?
    return :passed if course_passed?(course)
    :active
  end

  def course_passed?(course)
    course_lectures = course.lectures.pluck(:id)
    passed_lectures = results_for_course(course).passed.joins(:task).pluck(:lecture_id)
    (course_lectures - passed_lectures).blank?
  end

  def block_status(block, course)
    return :unavailable if [:unavailable, :expired].include?(course_status(course))
    current_block = current_block_for_course(course)
    if current_block.blank?
      :unavailable
    elsif block == current_block
      :current
    elsif course.block_position(block) < course.block_position(current_block)
      :passed
    else
      :unavailable
    end
  end

  def lecture_status(lecture, course)
    return :unavailable if [:unavailable, :expired].include?(course_status(course))
    current_lecture = current_lecture_for_course(course)
    if current_lecture.blank?
      :unavailable
    elsif lecture == current_lecture
      :current
    elsif course.lecture_position(lecture) < course.lecture_position(current_lecture)
      :passed
    else
      :unavailable
    end
  end

  def notes_text(group)
    result = []
    group_subscription = subscription_by_group(group.id)
    result << "Нет договора" unless group_subscription.subscription_contract
    current_time = Time.current
    payment_logs = PaymentLog.where(group: group, student: self)
    plan = group_subscription.payments.where("payed_on <= ?", current_time).sum(:amount)
    fact = payment_logs.where(group: group, student: self).where("payed_on <= ?", current_time).sum(:amount)
    result << "Проверить оплату" if plan > fact
    result << "Проверить подписи на договоре" if payment_logs.where(payment_type: %w(bank site)).any? && !group_subscription.subscription_contract.try(:user_file?)
    result << "Академ. отпуск" if group_subscription.academic_vacation
    result << "Не загружены документы об образовании" unless document_copies.any?
    result << "Не загружена копия паспорта" unless student_documents.with_document_type(:passport).any?
    result << "Не загружена мед. книжка" unless student_documents.with_document_type(:health_insurance).any?
    result << "Доп. соглашение о базе практики" if group_subscription.practice_practice?
    result << "Не загружено фото" unless student_documents.with_document_type(:photo).any?
    result.join(", ")
  end

  def other_courses(course)
    courses = available_subscriptions.where("group_subscriptions.end_on > ?", Time.current).map(&:course).select(&:active?).uniq
    courses.reject { |other_course| other_course.id == course.id }.sort_by(&:name).uniq
  end

  def best_result_for_lecture(lecture)
    results
      .unscope(:order)
      .where(task: lecture.task)
      .order("mark DESC NULLS LAST")
      .first
  end

  def result_for_lecture(lecture)
    if lecture.task.final?
      result = results
                 .unscope(:order)
                 .where(task: lecture.task,
                        passed: true)
                 .order("mark DESC NULLS LAST")
                 .first
    end

    result || results.where(task: lecture.task).last
  end

  def course_has_failed_task?(course)
    course.lectures.any? { |l| task_failed?(l.task) }
  end

  def task_failed?(task)
    task.max_attempts_count.present? &&
      results.where(task: task, passed: false, status: :marked).count >= task.max_attempts_count
  end

  def task_attempts_available?(task)
    task.max_attempts_count.blank? ||
      results.where(task: task).count < task.max_attempts_count
  end

  def lecture_task_available?(task, course)
    if task.final?
      lecture_available = !(lecture_status(task.lecture, course) == :unavailable)
    else
      lecture_available = !(lecture_status(task.lecture, course) == :unavailable || lecture_on_mark_or_passed?(task.lecture))
    end

    task_attempts_available?(task) &&
      all_previous_lectures_on_mark_or_passed?(task.lecture, course) && lecture_available
  end

  def all_previous_lectures_on_mark_or_passed?(lecture, course)
    previous_lectures = course.lectures.select { |l| course.lecture_position(l) < course.lecture_position(lecture) }
    previous_lectures.all? { |l| lecture_on_mark_or_passed?(l) }
  end

  def lecture_on_mark_or_passed?(lecture)
    last_result = result_for_lecture(lecture)
    last_result.present? && (last_result.passed? || last_result.on_mark?)
  end

  def lecture_passed?(lecture)
    last_result = result_for_lecture(lecture)
    last_result.present? && last_result.passed?
  end

  def lecture_has_mark_status?(lecture)
    last_result = result_for_lecture(lecture)
    last_result.present? && (last_result.marked? || last_result.on_mark? || last_result.time_expired?)
  end

  def passed_lectures(course)
    lectures = []
    course.active_blocks.each do |block|
      block.lectures.each do |lecture|
        lectures << lecture if lecture_passed?(lecture)
      end
    end
    lectures
  end

  def last_marked_lecture_for_course(course)
    last_lecture = nil
    course.active_blocks.each do |block|
      block.lectures.each do |lecture|
        if lecture_has_mark_status?(lecture)
          last_lecture = lecture
        else
          return last_lecture
        end
      end
    end
    last_lecture
  end

  def current_lecture_for_course(course)
    @current_lecture ||= {}
    @current_lecture[course.id] ||= _current_lecture_for_course(course)
  end

  def current_block_for_course(course)
    current_lecture = current_lecture_for_course(course)
    current_lecture.block if current_lecture
  end

  def progress_for_course(course)
    @progress ||= {}
    @progress[course.id] ||= _progress_for_course(course)
  end

  def group_subscription_for_course(course)
    @group_subscription_for_course ||= {}
    @group_subscription_for_course[course.id] ||= available_subscriptions.for_course(course.id).first
  end

  def any_group_subscription_for_course(course)
    @any_group_subscription_for_course ||= {}
    @any_group_subscription_for_course[course.id] ||= all_group_subscriptions.for_course(course.id).first
  end

  def group_for_course(course)
    group_subscription_for_course(course).group
  end

  def notices_for_course(course)
    notices = group_for_course(course).notices
    notices.for_student(self)
  end

  def delete_notice!(notice)
    transaction do
      ActiveRecord::Base.connection.execute("LOCK TABLE deleted_notices IN ACCESS EXCLUSIVE MODE")
      deleted_notices.create!(notice: notice) unless deleted_notices.where(notice: notice).exists?
    end
  end

  def all_passed_tasks
    @total_passed_tasks ||= results.where(passed: true).count
  end

  def total_passed_tasks(course)
    passed_lectures(course).count
  end

  def total_rest_tasks(course)
    course.total_tasks - total_passed_tasks(course)
  end

  def total_passed_hours(course)
    passed_lectures(course).sum { |l| l.time || 0 }
  end

  def total_rest_hours(course)
    course.total_hours - total_passed_hours(course)
  end

  def on_mark_results(course)
    results.includes(task: :lecture).where(status: :on_mark, tasks: { lecture_id: course.lectures.map(&:id) })
  end

  def marked_results(course)
    results.includes(task: :lecture).where(type: %w(ResultEssay ResultFile ResultText),
                                           status: :marked,
                                           tasks: { lecture_id: course.lectures.map(&:id) })
  end

  def group_subscriptions_for_instructor(instructor)
    group_subscriptions.with_deleted.joins(:group).where("instructor_id = ?", instructor.id)
  end

  def unlinked?
    group_subscriptions.blank?
  end

  def generated_email
    return "#{amocrm_id}#{FAKE_EMAIL_POSTFIX}" if amocrm_id.present?
    "#{phone}#{FAKE_EMAIL_POSTFIX}" if phone.present?
  end

  def generated_email?
    email == generated_email
  end

  def init_defaults
    if [:first_name, :last_name].any? { |field| send("#{field}_changed?") } && [first_name, last_name].any?(&:present?)
      self.translit_name = [first_name, last_name].map { |str| FmsTransliterator.transliterate(str) }.join("\s").strip
    end

    if emails_changed? && emails.present? && generated_email?
      return if User.where.not(id: id).where(email: emails.first).exists?
      self.email = emails.shift
    end
  end

  def amocrm_url
    URI.join(Amorail.config.api_endpoint, "/contacts/detail/", amocrm_id.to_s).to_s if amocrm_id.present?
  end

  def skip_sync_amo_data!
    self.skip_sync_amo_data = true
  end

  def sync_amo_data?
    !skip_sync_amo_data && amocrm_id.present? && AMO_SYNC_FIELDS.any? { |field| send("#{field}_changed?") }
  end

  def sync_amo_data
    Delayed::Job.enqueue(SyncAmoDataJob.new(id), queue: :amocrm)
  end

  def update_campaign
    update_columns(campaign_id: Campaign.find_by(name: comagic_campaign).try(:id))
  end

  def cart_subscriptions
    @cart_subscriptions ||= _load_cart_subscriptions
  end

  def created_subscriptions_count
    cart_subscriptions.count
  end

  def missing_docs_list
    result = []
    result << "Копии документов об образовании" unless document_copies.any?
    result << "Копия паспорта (первая страница + прописка)" unless student_documents.with_document_type(:passport).any?
    result << "Медицинская книжка (терапевт и дерматовенеролог) или справка учащегося формы 086у с записью от дерматолога" unless student_documents.with_document_type(:health_insurance).any?
    result << "Свидетельство о заключении брака/смене фамилии (если в дипломах и паспорте разные фамилии)" unless student_documents.with_document_type(:name_change_certificate).any?
    result.join(", ")
  end

  def have_mail_missing_docs_about?(time_interval)
    self.mailing_journals
        .where('mailing_title = ?', "missing_docs")
        .where('created_at > ?', (Date.today - time_interval))
        .any?
  end

  def have_mail_k_dist_materials_about?(time_interval)
    self.mailing_journals
        .where('mailing_title = ?', "k_dist_materials_promotion")
        .where('created_at > ?', (Date.today - time_interval))
        .any?
  end

  def create_journal_entry_missing_docs_mailing_about
    self.mailing_journals.create(mailing_title: "missing_docs")
  end

  def create_journal_entry_final_notification_about
    self.mailing_journals.create(mailing_title: "final_notification")
  end

  def create_journal_entry_k_dist_materials_mailing_about
    self.mailing_journals.create(mailing_title: "k_dist_materials_promotion")
  end

  private

  def _current_lecture_for_course(course)
    course.active_blocks.each do |block|
      block.lectures.each do |lecture|
        return lecture unless lecture_on_mark_or_passed?(lecture)
      end
    end
    course.active_blocks.last.try(:lectures).try(:last)
  end

  def _progress_for_course(course)
    if course.total_hours > 0
      total_passed_hours(course) * 100 / course.total_hours.to_f
    else
      0
    end
  end

  def _load_cart_subscriptions
    group_subscriptions.created_not_actual_ordered.each do |subscription|
      GroupSubscriptions::Actualizer.new(subscription).actualize
    end
    group_subscriptions.created_not_actual_ordered
  end
end


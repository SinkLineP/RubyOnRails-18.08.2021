# == Schema Information
#
# Table name: group_subscriptions
#
#  id                            :integer          not null, primary key
#  student_id                    :integer
#  group_id                      :integer
#  begin_on                      :date
#  end_on                        :date
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#  education_form_id             :integer
#  discount_id                   :integer
#  price                         :float            default(0.0), not null
#  payer                         :text
#  amocrm_id                     :text
#  group_price_id                :integer
#  amocrm_status_id              :integer
#  imported_from_amo             :boolean          default(FALSE), not null
#  practice                      :text
#  practice_basis_id             :integer
#  payer_type                    :text
#  appendix_signed_on            :datetime
#  appendix_expired_on           :datetime
#  practice_agreement_signed_on  :datetime
#  payer_agreement_signed_on     :datetime
#  itec                          :text
#  expelled                      :boolean          default(FALSE), not null
#  academic_vacation             :boolean          default(FALSE), not null
#  vacation_begin_on             :date
#  vacation_end_on               :date
#  sale_success_on               :datetime
#  created_by_user               :boolean          default(FALSE)
#  pending_payment_at            :datetime
#  responsible_name              :text
#  amocrm_tags                   :text             is an Array
#  amo_module_id                 :integer
#  rating_place                  :integer          default(0)
#  rating_score                  :integer          default(0)
#  shop_id                       :integer
#  one_time_payment              :boolean          default(FALSE), not null
#  created_from_module           :boolean          default(FALSE), not null
#  module_group_id               :integer
#  practice_entrance_agree       :boolean          default(FALSE), not null
#  practice_entrance_agree_at    :datetime
#  practice_entrance_disagree    :boolean          default(FALSE), not null
#  practice_entrance_disagree_at :datetime
#  practice_date                 :datetime
#  practice_date_at              :datetime
#  amo_module_at                 :datetime
#  promotion_id                  :integer
#  promotion_source              :text
#  update_job_id                 :integer
#  double_created                :boolean          default(FALSE), not null
#
# Indexes
#
#  index_group_subscriptions_on_amo_module_id            (amo_module_id)
#  index_group_subscriptions_on_amocrm_status_id         (amocrm_status_id)
#  index_group_subscriptions_on_deleted_at               (deleted_at)
#  index_group_subscriptions_on_discount_id              (discount_id)
#  index_group_subscriptions_on_education_form_id        (education_form_id)
#  index_group_subscriptions_on_group_id_and_student_id  (group_id,student_id) UNIQUE
#  index_group_subscriptions_on_group_price_id           (group_price_id)
#  index_group_subscriptions_on_module_group_id          (module_group_id)
#  index_group_subscriptions_on_practice_basis_id        (practice_basis_id)
#  index_group_subscriptions_on_promotion_id             (promotion_id)
#  index_group_subscriptions_on_shop_id                  (shop_id)
#

class GroupSubscription < ActiveRecord::Base
  extend Enumerize
  extend ReplaceableNestedAttributes
  include SubscriptionDelegates
  include TimeFormatHelper

  EXPIRE_PERIOD = 6
  ENCOURAGING_EXPIRE_PERIOD = 12
  COURSES_FOR_PROMOTION = %w(K KO KOV KV KC SK)
  AMO_SYNC_FIELDS = %i(promotion_id promotion_source)
  DISABLED_SEND = %w[CHIO-CHIO]
  SUCCESSFULLY_IMPLEMENTED = 1 # Для статуса сделки "Успешно реализовано" amocrm_status_id = 1
  K_DIST = 412 # K-dist course id is 412

  belongs_to :shop
  belongs_to :education_form, inverse_of: :group_subscriptions
  belongs_to :discount, inverse_of: :group_subscriptions
  belongs_to :promotion, inverse_of: :group_subscriptions
  belongs_to :student, inverse_of: :group_subscriptions
  belongs_to :group, -> { with_deleted }, inverse_of: :subscriptions
  belongs_to :group_price, inverse_of: :group_subscriptions
  belongs_to :amocrm_status, inverse_of: :group_subscriptions
  belongs_to :practice_basis, inverse_of: :group_subscriptions
  belongs_to :amo_module, inverse_of: :group_subscriptions
  belongs_to :module_group, inverse_of: :module_subscription
  has_one :course, through: :group
  has_one :faculty, through: :course
  has_one :instructor, through: :group
  has_many :group_transfers, -> { order(:created_at) }, inverse_of: :group_subscription, dependent: :destroy
  has_many :change_group_orders, through: :group_transfers
  has_many :course_links, through: :course
  has_many :payments, -> { order(:payed_on) }, dependent: :destroy, inverse_of: :group_subscription
  has_many :subscription_documents, inverse_of: :group_subscription, dependent: :destroy
  has_many :education_documents, through: :subscription_documents
  has_many :practices, through: :group
  has_many :notes, ->() { order(:noted_at) }, as: :notable, dependent: :delete_all
  has_one :payment_requisite, inverse_of: :group_subscription, dependent: :destroy
  has_many :sms, inverse_of: :group_subscription, dependent: :nullify
  has_many :order_group_subscriptions, inverse_of: :group_subscription, dependent: :destroy
  has_many :orders, through: :order_group_subscriptions
  has_many :expelled_students,
           ->(subscription) { joins(:expulsion).where(expulsions: { group_id: subscription.group_id }) },
           through: :student
  has_many :expulsions, through: :expelled_students
  has_many :blocks, through: :course
  has_many :lectures, through: :blocks
  has_many :generated_documents, as: :item, dependent: :destroy
  has_many :working_off_lists, inverse_of: :group_subscription, dependent: :destroy
  has_one :order_contract, as: :item
  has_one :subscription_contract, as: :item
  has_one :education_certificate, as: :item
  has_one :payer_agreement, as: :item
  has_one :practice_agreement, as: :item
  has_one :questionnaire, as: :item
  has_one :vacation_order, as: :item
  has_one :expulsion_notification, as: :item
  has_many :module_courses, through: :amo_module, source: :courses
  has_many :survey_responses, inverse_of: :group_subscription, dependent: :destroy
  has_many :module_groups, ->() { order(:course_id) }, inverse_of: :group_subscription, dependent: :destroy
  has_many :module_subscriptions, through: :module_groups, source: :module_subscription
  has_many :cash_receipts, as: :item, dependent: :nullify
  has_many :call_results, inverse_of: :group_subscription, dependent: :destroy

  acts_as_paranoid

  attr_accessor :skip_group_validation
  delegate :bank_installment?, to: :group_price, allow_nil: true

  accepts_nested_attributes_for :subscription_documents, allow_destroy: true
  accepts_nested_attributes_for :payments, allow_destroy: true
  accepts_nested_attributes_for :order_contract
  accepts_nested_attributes_for :subscription_contract
  accepts_nested_attributes_for :payer_agreement
  accepts_nested_attributes_for :practice_agreement
  accepts_nested_attributes_for :questionnaire
  accepts_nested_attributes_for :payment_requisite
  accepts_nested_attributes_for :vacation_order
  accepts_nested_attributes_for :expulsions
  accepts_nested_attributes_for :working_off_lists, allow_destroy: true
  accepts_nested_attributes_for :module_groups, allow_destroy: true
  accepts_nested_attributes_for :change_group_orders
  accepts_nested_attributes_for :education_certificate

  replaceable_nested_attributes :payments
  replaceable_nested_attributes :subscription_documents

  enumerize :practice, in: %i[institute practice], default: :institute, predicates: { prefix: true }
  enumerize :payer_type, in: %i[student government other], default: :student, predicates: { prefix: true }

  mount_uploader :itec, FileUploader

  validates :begin_on, :end_on, :group_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate :check_multiple_group_subscriptions, unless: :skip_group_validation
  validates_associated :subscription_documents
  validates :vacation_begin_on, :vacation_end_on, presence: true, if: :academic_vacation?

  before_validation do
    self.shop_id ||= group.shop_id if group.present?
    set_amo_module
  end

  before_create do
    calculate_payments if payments.blank?
    generate_subscription_documents if subscription_documents.blank?
  end

  # Отправляем студенту письмо о необходимости загрузить недостающие документы
  before_save :missing_student_docs_mailing, if: :deal_status_will_change_to_successfully_implemented?

  after_save if: :academic_vacation_changed? do
    if generate_vacation_order? && vacation_duration > 0
      update_columns(end_on: end_on + vacation_duration.days)
      payments.select { |p| p.payed_on && p.payed_on > Date.current }.each { |p| p.update_columns(payed_on: p.payed_on + vacation_duration.days) }
      return if disabled_send?
      NotificationMailer.notify_about_academic_vacation(self).deliver!
    else
      vacation_order.destroy! if vacation_order
    end
  end

  after_save if: :status_changed_to_success_and_not_double? do
    update_columns(sale_success_on: Time.current)
    update_columns(double_created: true)
    Delayed::Job.enqueue(Amocrm::Operations::DuplicateLead.new(amocrm_id, group_id), queue: :amocrm)
  end

  after_save if: :status_changed_to_meeting? do
    return if disabled_send?
    CosmetologyMailer.meeting_status_notification(self).deliver!
  end

  after_save if: :education_dates_changed? do
    update_one_time_payment if COURSES_FOR_PROMOTION.include?(course.short_name)
  end

  after_save do
    checking_fields_changes
    if amo_module_id.present? && status_changed_to_success?
      GroupSubscriptions::ModuleGroupsBuilder.new(self).build!
    end
    group.recalculate_counters
  end

  after_save if: :expelled_changed? do
    group.expel_student!(student) if expelled?
  end

  after_destroy do
    group.recalculate_counters
  end

  after_save :change_group, if: :change_group?

  after_update :sync_amo_data, if: :sync_amo_data?

  after_save if: :itec_changed? do
    if itec?
      return if disabled_send?
      NotificationMailer.notify_about_itec(student).deliver!
      SmsNotifications.new.notify_about_itec!(self)
    end
  end

    # Если курс K-dist и этап продажи в рамках текущей транзакции меняется на "Успешно реализовано", отправляем студенту предложение о покупке набора материалов для курса
    after_save if: :course_is_K_dist? do
      if :deal_status_will_change_to_successfully_implemented?
        k_dist_mailing
      end
    end

  scope :ordered, ->() { order(begin_on: :desc) }
  scope :expired, ->() { where("(group_subscriptions.one_time_payment = 'false' and group_subscriptions.end_on + INTERVAL '6 month' < :date) or (group_subscriptions.one_time_payment = 'true' and group_subscriptions.end_on + INTERVAL '12 month' < :date)", date: Date.current) }
  scope :not_expired, ->() { where.not("(group_subscriptions.one_time_payment = 'false' and group_subscriptions.end_on + INTERVAL '6 month' < :date) or (group_subscriptions.one_time_payment = 'true' and group_subscriptions.end_on + INTERVAL '12 month' < :date)", date: Date.current) }
  scope :not_ended, ->() { where('group_subscriptions.end_on >= ?', Date.current) }
  scope :actual_practices, -> { joins(:practices).where('practices.end_on > ?', Date.current) }
  scope :actual, ->() { where(amocrm_status_id: AmocrmStatus.success.id) }
  scope :not_actual, ->() { where.not(amocrm_status_id: AmocrmStatus.success.id) }
  scope :academic_vacation, ->() { where(academic_vacation: true).where('group_subscriptions.vacation_begin_on <= :date AND :date <= group_subscriptions.vacation_end_on', date: Date.current) }
  scope :not_academic_vacation, ->() { where('group_subscriptions.academic_vacation = :vacation OR (group_subscriptions.vacation_begin_on > :date OR group_subscriptions.vacation_end_on < :date)', vacation: false, date: Date.current) }
  scope :expelled, ->() { where(expelled: true) }
  scope :not_expelled, ->() { where(expelled: false) }
  scope :active, ->() { actual.not_expired.not_expelled.not_academic_vacation }
  scope :for_course, ->(course_id) { includes(:group).references(:group).where('groups.course_id = :course_id', course_id: course_id).order('group_subscriptions.end_on desc').distinct }
  scope :payment_not_completed, ->() { where.not(pending_payment_at: nil) }
  scope :created_not_actual_ordered, ->() { all_created_by_user.where('group_subscriptions.pending_payment_at IS NULL AND (group_subscriptions.amocrm_status_id IS NULL OR group_subscriptions.amocrm_status_id != ?)', AmocrmStatus.success.id).ordered }
  scope :all_created_by_user, ->() { where(created_by_user: true) }
  scope :with_instructors, ->() { joins(:group).where('groups.instructor_id IS NOT NULL') }
  scope :with_course_links, -> { joins(:course_links).uniq }
  scope :with_long_courses, ->() { joins(:course).merge(Course.long_courses) }
  scope :with_short_courses, ->() { joins(:course).merge(Course.short_courses) }
  scope :with_multiple_payments, -> { where(id: Payment.group(:group_subscription_id).having('count(*) > 1').select(:group_subscription_id)) }
  scope :with_generated_documents, ->() { joins(:generated_documents).uniq }
  scope :with_course, ->(course) { joins(:course).where(courses: { id: course.id }) }
  scope :without_courses, ->(short_names) { joins(:course).where.not(courses: { short_name: short_names }) }
  scope :ordered_by_rating_score, ->() { order(rating_score: :desc).ordered }
  scope :ordered_by_rating_place, ->() { order(:rating_place).ordered }
  scope :top_rating, ->() { where(rating_place: 1..3) }
  scope :not_created_from_module, ->() { where(created_from_module: false) }
  scope :created_from_module, ->() { where(created_from_module: true) }
  scope :created_form_module_without_module, ->() { created_from_module.where(module_group_id: nil) }
  scope :not_government, ->() {where.not(payer_type: 'government')}
  scope :disabled_send, ->() { joins(:course).where.not(courses: { short_name: DISABLED_SEND }) }

  def courses
    @courses ||= ([course] + module_courses).uniq
  end

  def expulsions_attributes=(value)
    value.each do |expulsion_array|
      expulsion = Expulsion.find_by(id: expulsion_array.second[:id])
      return unless expulsion
      expulsion.assign_attributes(expulsion_array.second)
      expulsion.save
    end
  end

  def amocrm_tags
    read_attribute(:amocrm_tags) || []
  end

  def amocrm_url
    URI.join(Amorail.config.api_endpoint, '/leads/detail/', amocrm_id.to_s).to_s if amocrm_id.present?
  end

  def sync_amo_data?
    amocrm_id.present? && AMO_SYNC_FIELDS.any? { |field| send("#{field}_changed?") }
  end

  def sync_amo_data
    # Delayed::Job.enqueue(SyncAmoLeadJob.new(id), queue: :amocrm)
  end

  def documents_list
    course_name = course.short_name
    return I18n.t('documents_list.ko') if %w[KO THE PREST KOV].include?(course_name)
    return I18n.t('documents_list.sk') if %w[SK EST].include?(course_name)
    return I18n.t('documents_list.kc') if %w[KC KV].include?(course_name)

    education_documents.map { |d| d.description.presence || d.title }.join(",\s")
  end

  def contract_with_appendix?
    practice == :institute
  end

  def generate_practice_agreement?
    practice == :practice
  end

  def generate_payer_agreement?
    payer_type == :other
  end

  def government?
    payer_type == :government
  end

  def generate_vacation_order?
    academic_vacation? && vacation_begin_on.present? && vacation_end_on.present?
  end

  def vacation_duration
    (vacation_end_on - vacation_begin_on).to_i
  end

  def change_group_order
    actual_group_transfer.try(:change_group_order)
  end

  def actual_group_transfer
    @actual_group_transfer ||= group_transfers.ordered.last
  end

  def active?
    !inactive?
  end

  def inactive?
    [
      !success?,
      expired?,
      deleted?,
      expelled?,
      in_academic_vacation?
    ].any?
  end

  def expired?
    access_expires_on < Date.today
  end

  def expire_period_for_course
    one_time_payment? ? ENCOURAGING_EXPIRE_PERIOD.months : EXPIRE_PERIOD.months
  end

  def not_alone?
    order_group_subscriptions.present? && order_count >= 2
  end

  def order_count
    order_group_subscriptions.first.subscriptions_count
  end

  def order_subscriptions
    order_group_subscriptions.first.order.group_subscriptions
  end

  def in_future?
    begin_on > Date.today
  end

  def to
    deleted_at || access_expires_on
  end

  def was_in_vacation_while_practice?(begin_date, end_date)
    !(vacation_end_on < begin_date || vacation_begin_on > end_date)
  end

  def in_academic_vacation?
    return false unless academic_vacation?
    return true if vacation_begin_on.blank? || vacation_end_on.blank?
    vacation_begin_on <= Date.current && Date.current <= vacation_end_on
  end

  def access_expires_on
    end_on + expire_period_for_course
  end

  def status_changed_to_success?
    amocrm_status_id_changed? && success?
  end

  def status_changed_to_success_and_not_double?
    amocrm_status_id_changed? && success? && !double_created
  end

  def status_changed_to_primary_treatment?
    amocrm_status_id_changed? && treatment?
  end

  def status_changed_to_meeting?
    amocrm_status_id_changed? && meeting?
  end

  def change_group?
    !created_from_module? && group_id_changed? && success?
  end

  def calculate_payments
    return if group.blank? || group_price.blank? || created_from_module?

    payment_amounts = group_price.payment_amounts
    created_on = persisted? ? created_at.to_date : Date.current
    first_date = [group.begin_on.beginning_of_month, created_on.beginning_of_month].max

    self.payments = payment_amounts.each_with_index.map do |amount, idx|
      if idx == 0
        payments.new(payed_on: created_on, amount: amount)
      else
        payments.new(payed_on: first_date + idx.month, amount: amount)
      end
    end

    self.price = payments.to_a.sum(&:amount)

    if discount.present? && payments.present?
      last_payment = payments.last
      last_payment.amount -= discount.calculate(price)
      self.price = payments.to_a.sum(&:amount)
    end

    payments
  end

  def old_group
    @old_group ||= actual_group_transfer.try(:old_group)
  end

  def price_without_discount
    @price_without_discount ||= group_price.try(:payment_amounts).try(:sum).to_f
  end

  def discount_amount
    @discount_amount ||= [0, price_without_discount - price].max
  end

  def price_with_discount
    price_without_discount - discount_amount
  end

  def save_and_generate_documents!
    save!

    with_lock do
      generate_subscription_documents if subscription_documents.blank?

      (subscription_contract || build_subscription_contract).generate!

      if generate_practice_agreement?
        (practice_agreement || build_practice_agreement).generate!(number: 1)
      else
        practice_agreement.destroy! if practice_agreement
      end

      (questionnaire || build_questionnaire).generate!

      if generate_vacation_order?
        (vacation_order || build_vacation_order).generate!
      else
        vacation_order.destroy! if vacation_order
      end

      group_transfers.each { |group_transfer| group_transfer.change_group_order.generate! if group_transfer.correct? && group_transfer.change_group_order }
    end
  end

  def save_and_generate_documents_for_order!
    save!

    with_lock do
      generate_subscription_documents if subscription_documents.blank?

      (subscription_contract || build_subscription_contract).generate!

      if generate_practice_agreement?
        (practice_agreement || build_practice_agreement).generate!(number: 1)
      else
        practice_agreement.destroy! if practice_agreement
      end

      (questionnaire || build_questionnaire).generate!

      if generate_vacation_order?
        (vacation_order || build_vacation_order).generate!
      else
        vacation_order.destroy! if vacation_order
      end

      group_transfers.each { |group_transfer| group_transfer.change_group_order.generate! if group_transfer.correct? && group_transfer.change_group_order }
    end
  end

  def save_and_generate_subscription_documents!
    transaction do
      save!
      subscription_documents.each(&:save!)
    end
  end

  def generate_subscription_documents
    return if student.blank? || course.blank?
    courses.each do |course|
      course.course_documents.where(education_level: student.education_level).each do |course_document|
        education_document = course_document.education_document
        next unless education_document
        subscription_documents.find_or_initialize_by(education_document: education_document,
                                                     course: course)
      end
    end
  end

  def old_group_name
    actual_group_transfer.try(:old_group).try(:title).to_s
  end

  def not_passed_lectures
    @not_passed_lectures ||= course.lectures.select { |l| !student.lecture_on_mark_or_passed?(l) }
  end

  def offline?
    education_form == EducationForm.offline
  end

  def online?
    education_form == EducationForm.online
  end

  def success?
    amocrm_status_id == AmocrmStatus.success.id
  end

  def treatment?
    AmocrmStatus.primary_treatment_statuses.exists?(amocrm_status_id)
  end

  def meeting?
    AmocrmStatus.meeting_statuses.exists?(amocrm_status_id)
  end

  def first_payment_amount
    payments.first.try(:amount).to_f
  end

  def has_many_payments?
    payments.count > 1
  end

  def zero_price_with_installment?
    has_many_payments? && first_payment_amount.zero? && bank_installment?
  end

  def nearest_payment_amount
    nearest_payment = pending_payments.first
    nearest_payment ? (nearest_payment.amount - overpaid) : debts_sum
  end

  def last_order
    order_group_subscriptions.last.try(:order)
  end

  def payment_amount(order)
    if order.cart?
      first_payment_amount
    else
      order.full? ? debts_sum : nearest_payment_amount
    end
  end

  def info
    [expelled && 'О', in_academic_vacation? && 'А'].reject(&:blank?).join('')
  end

  def order
    order_group_subscriptions.first.try(:order)
  end

  def order_not_zero_subscriptions
    return [] unless order
    order.not_zero_subscriptions
  end

  def change_group
    GroupSubscriptions::ChangeGroup.new(self).perform
  end

  delegate :paid_status,
           :paid?,
           :debts_sum,
           :current_plan,
           :plan_total,
           :fact,
           :completed_payments,
           :pending_payments,
           :overpaid,
           :archived?,
           :last_plan_payment_date,
           :current_debt_sum,
           :current_debt?,
           :plan_payment_debt_dates,
           to: :payments_info

  def payments_info
    @payments_info ||= GroupSubscriptions::Payments.new(self)
  end

  def has_debts?
    paid_status == 'debts'
  end

  def suspended?
    return false if government?
    current_debt? && last_plan_payment_date < Date.current - 5.days
  end

  def show_rating?
    success? && !expelled? && !in_academic_vacation?
  end

  def update_one_time_payment
    update_columns(one_time_payment: !has_many_payments? && !first_payment_amount.zero?)
  end

  def practice_entrance
    agreement_text = 'Н/Д'
    agreement_text = "Да(#{format_datetime(practice_entrance_agree_at)})" if practice_entrance_agree
    agreement_text = "Нет(#{format_datetime(practice_entrance_disagree_at)})" if practice_entrance_disagree
    agreement_text = agreement_text + "\n C #{format_datetime(practice_date)}(#{format_datetime(practice_date_at)})" if practice_date.present?
    agreement_text
  end

  def amo_module_text
    return unless amo_module
    [amo_module.title, "(#{format_datetime(amo_module_at)})"].join
  end

  def disabled_send?
    DISABLED_SEND.include?(course.short_name)
  end

  private

  def set_amo_module
    return if amo_module.present? || course.additional_amo_module.blank?

    self.amo_module = course.additional_amo_module
  end

  def checking_fields_changes
    %w(practice_entrance_agree practice_entrance_disagree practice_date ).each{|field|  update_column("#{field}_at", Time.now) if send("#{field}_changed?")}
    update_column(:amo_module_at, Time.now) if amo_module_id_changed?
  end

  def education_dates_changed?
    begin_on_changed? || end_on_changed?
  end

  def check_multiple_group_subscriptions
    return if group.blank? || student.blank?
    student_course_ids = student.group_subscriptions.select { |gs| !gs.new_record? && gs.id != id && gs.course.present? }.map { |gs| gs.course.id }
    has_multiple_subscriptions = student_course_ids.any? { |id| id == group.course_id }
    if has_multiple_subscriptions
      logger.info("has_multiple_subscriptions:  student_course_ids = #{student_course_ids}; group_id = #{group.id}; student_id = #{student.id}")
      errors.add(:base, :has_multiple_subscriptions)
    end
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/group_subscriptions.log")
  end

  # Статус сделки будет изменен на "Успешно реализовано" ?
  def deal_status_will_change_to_successfully_implemented?
    (self.amocrm_status_id == SUCCESSFULLY_IMPLEMENTED) && self.amocrm_status_id_changed?
  end

  def missing_student_docs_mailing
    if self.course.student_docs_required
      unless (self.student.missing_docs_list.empty? || self.student.have_mail_missing_docs_about?(1.month))
        NotificationMailer.notify_about_missing_student_docs(self.student).deliver_later
        self.student.create_journal_entry_missing_docs_mailing_about
      end
    end
  end

  def course_is_K_dist?
    self.course.id == K_DIST
  end

  def k_dist_mailing
    unless self.student.have_mail_k_dist_materials_about?(1.day)
      NotificationMailer.notify_about_materials_for_k_dist(self.student).deliver_later
      self.student.create_journal_entry_k_dist_materials_mailing_about
    end
  end
end

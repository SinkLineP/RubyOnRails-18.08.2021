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

class Instructor < User
  has_many :all_groups, -> { with_deleted }, class_name: 'Group', dependent: :nullify
  has_many :groups, inverse_of: :instructor, dependent: :nullify
  has_many :courses, through: :groups
  has_many :lectures, -> { uniq }, through: :courses
  has_many :tasks, through: :lectures
  has_many :students, -> { ordered.uniq }, through: :groups
  has_many :active_students, -> { ordered.uniq }, through: :groups
  has_many :letters, inverse_of: :instructor, dependent: :destroy
  has_many :work_results, -> { uniq }, through: :groups
  has_many :course_instructors, dependent: :destroy, inverse_of: :instructor
  has_many :linked_courses, through: :course_instructors, source: :course
  has_many :instructor_faculties, -> { order(:position) }, dependent: :destroy, inverse_of: :instructor
  has_many :faculties, through: :instructor_faculties
  has_many :specialities, through: :linked_courses
  has_many :study_questions, inverse_of: :instructor, dependent: :destroy
  has_many :working_off_lists, dependent: :nullify, inverse_of: :instructor
  has_many :instructor_works, -> { order(:created_at) }, dependent: :destroy, inverse_of: :instructor
  has_many :works, through: :instructor_works
  has_many :vacations, class_name: 'InstructorVacation', dependent: :destroy, inverse_of: :instructor
  has_many :schedule_items, dependent: :nullify, inverse_of: :instructor
  has_one :instructor_home, dependent: :destroy
  accepts_nested_attributes_for :instructor_works, allow_destroy: true
  accepts_nested_attributes_for :instructor_home, allow_destroy: true

  validates :first_name, :last_name, presence: true
  validate :validate_duplicated_works
  scope :alphabetical_order, -> { order(:last_name, :first_name, :middle_name) }
  scope :with_email_passwords, -> { where.not(encrypted_email_password: nil) }
  scope :with_speciality, ->(speciality) { joins(:specialities).where(specialities: { parent_id: speciality.id }).uniq }
  scope :home_page, -> { joins(:instructor_home).where(instructor_homes: { active: true }).order(last_name: :asc) }

  def last_letter_uid(folder)
    letters.send(folder).with_uids.order(:uid).last.try(:uid)
  end

  # for correct ordering
  # TODO (vl): refactor this
  def faculty_ids=(faculty_ids = [])
    faculty_ids.each_with_index do |id, index|
      instructor_faculties.find_by(faculty_id: id).try(:update_column, :position, index + 1)
    end
    super
  end

  # for correct ordering
  # TODO (vl): refactor this
  def linked_course_ids=(course_ids = [])
    course_ids.each_with_index do |id, index|
      course_instructors.find_by(course_id: id).try(:update_column, :position, index + 1)
    end
    super
  end

  private

  def validate_duplicated_works
    works_ids = instructor_works.reject(&:marked_for_destruction?).map(&:work_id).compact
    errors.add(:base, 'Занятия не должны повторяться') if works_ids.size != works_ids.uniq.size
  end
end

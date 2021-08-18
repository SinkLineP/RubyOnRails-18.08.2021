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

class User < ActiveRecord::Base
  extend Enumerize
  extend StringArrayInput

  enumerize :source, in: %i(cosmetic barbershop dashboard amocrm none), default: :none, predicates: true

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :vkontakte, :odnoklassniki]

  has_one :blog_subscriber, inverse_of: :user, dependent: :nullify

  has_many :authentications, inverse_of: :user, dependent: :destroy
  has_one :user_total_activity, inverse_of: :user, dependent: :destroy

  has_one :api_key, inverse_of: :user, dependent: :destroy

  has_many :document_copies, dependent: :destroy, inverse_of: :user, as: :item
  has_many :student_documents, dependent: :destroy, inverse_of: :user
  has_many :orders, inverse_of: :user, dependent: :destroy
  has_many :rejected_subscriptions, inverse_of: :user, dependent: :destroy
  has_many :mailing_journals, inverse_of: :user, dependent: :destroy

  has_many :sms, inverse_of: :user, dependent: :nullify
  has_many :user_phones, dependent: :destroy

  accepts_nested_attributes_for :user_phones,
                                reject_if: :number_blank,
                                allow_destroy: true
  accepts_nested_attributes_for :document_copies, allow_destroy: true
  accepts_nested_attributes_for :student_documents, allow_destroy: true

  belongs_to :education_level, inverse_of: :users

  validates_format_of :email, with: Devise.email_regexp, allow_blank: true
  validates_presence_of :password, if: :validate_password

  scope :ordered, -> { order(:last_name, :email) }
  scope :users, -> { where.not(type: 'Administrator') }

  after_save :sanitize_phones
  after_create :update_blog_subscriber_if_present!
  after_save :increment_version
  before_validation :sanitize_name
  before_save if: :subscribed_on_blog_changed? do
    CoursesShop::CoursesShopMailer.user_subscribed_on_blog(self).deliver! if subscribed_on_blog?
  end

  attr_accessor :has_blog_subscription, :validate_password

  mount_uploader :avatar, UserAvatarUploader

  array_input_field :phones_array
  array_input_field :emails

  def self.find_by_email(email)
    User.where('lower(email)=?', email.downcase).first
  end

  def deleted?
    deleted_at.present?
  end

  def wordpress?
    wordpress_id.present?
  end

  def all_documents
    @all_documents ||= (document_copies + student_documents).to_a.sort_by(&:created_at).reverse
  end

  def devise_scope
    :user
  end

  def add_phone(phone_number)
    phone = user_phones.new(number: phone_number)
    unless phone.save
      # TODO: Add email notification about this
      Rails.logger.error("Cannot add number to user ##{id}. Number #{phone_number} already used.")
    end
  end

  def phone
    user_phones.first.number if user_phones.present?
  end

  def phones_string
    return user_phones.pluck(:number).join(",") if user_phones.present?
    nil
  end

  def phones_string=(value)
    return unless value.present?
    arr = value.split(',')
    arr.each do |phone|
      next if user_phones.pluck(:number).include?(phone)
      user_phones.create(number: phone)
    end
  end

  def can_sign_in?
    true
  end

  def authenticate_through?(provider)
    authentications.find_by(provider: provider).present?
  end

  def admin?
    is_a?(Administrator)
  end

  def student?
    is_a?(Student)
  end

  def instructor?
    is_a?(Instructor)
  end

  def manager?
    is_a?(Manager)
  end

  def short_name
    first_name || email
  end

  def courses_shop_name
    [last_name, first_name].reject(&:blank?).join(' ').presence || username
  end

  def display_name
    [last_name, first_name].reject(&:blank?).join(' ').presence || email
  end

  def display_name_official
    [first_name, middle_name].reject(&:blank?).join(' ').presence || email
  end

  def search_content
    [last_name, first_name, middle_name].reject(&:blank?).join(' ') || email
  end

  def name_for_subject
    first_name + ', ' if first_name?
  end

  def text_for_subject(subject)
    if first_name?
      first_name + ', ' + subject
    else
      subject.mb_chars.capitalize
    end
  end

  def full_name
    [last_name, first_name, middle_name].reject(&:blank?).join(' ') || username
  end

  def full_name_with_ids
    [full_name, email, id.to_s, amocrm_id].reject(&:blank?).join(' | ')
  end

  def full_name=(value)
    return if value.blank?
    names = value.strip.squish.split(' ')
    self.last_name, self.first_name, self.middle_name = names
    self.middle_name = names[2..-1].join(' ') if names.size > 3
  end

  def name_with_email
    name = [last_name, first_name].compact.join(' ')
    name.present? ? "#{name} (#{email})" : email
  end

  def email=(value)
    super
    self.last_name = username if last_name.blank?
  end

  def username
    email.split('@')[0] if email.present?
  end

  def email_password
    SymmetricEncryption.decrypt(encrypted_email_password) if encrypted_email_password.present?
  end

  def email_password=(value)
    self.encrypted_email_password = SymmetricEncryption.encrypt(value) if value.present?
  end

  def avatar_placeholder
    display_name[0].mb_chars.upcase
  end

  def has_blog_subscription?
    has_blog_subscription
  end

  def has_blog_subscription
    blog_subscriber.present?
  end

  def has_blog_subscription=(value)
    if ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(value)
      create_blog_subscriber!(user: self) if blog_subscriber.blank?
    else
      if blog_subscriber.present?
        blog_subscriber.destroy
        self.blog_subscriber = nil
      end
    end
  end

  def hide_tutorial!
    update_column(:hide_tutorial, true)
  end

  def sanitize_phones
    return if phones_array.blank?
    self.phones = sanitized_phones
  end

  def sanitized_phones
    phones_array.reject(&:blank?).uniq
  end

  def increment_version
    self.with_lock do
      self.update_column(:version, version + 1)
    end
  end

  def sanitize_name
    [:first_name, :last_name, :middle_name].each do |name|
      value = send(name)
      send("#{name}=", value.strip.squish) if value.present?
    end
  end

  def phones_array
    user_phones.pluck(:number)
  end

  def phones_array=(numbers)
    sanitized_phones.each do |number|
      next if user_phones.pluck(:number).include?(number)
      user_phones << UserPhone.new(number: number)
    end
    save
  end

  private

  def update_blog_subscriber_if_present!
    subscriber = BlogSubscriber.find_by(email: email.downcase)
    subscriber.update!(user: self, email: nil) if subscriber.present?
  end

  def number_blank(attributes)
    attributes['id'].blank? && attributes['number'].blank?
  end
end

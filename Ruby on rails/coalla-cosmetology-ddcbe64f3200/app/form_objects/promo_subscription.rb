class PromoSubscription
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::MassAssignment
  include ActiveAttr::TypecastedAttributes

  attribute :phone_number
  attribute :email
  attribute :last_name
  attribute :course_id
  attribute :is_blog

  with_options presence: true do
    validates :is_blog, :phone_number
  end
  validates_format_of :email, with: Devise.email_regexp
  validate :email_exist
  validate :phone_exist

  def email_exist
    errors.add(:email, 'уже существует') if User.where("lower(email) = ?", email.downcase).exists?
  end

  def phone_exist
    if UserPhone.where(number: phone_number).present?
      errors.add(:phone_number, 'номер уже используется с другой эл. почтой') 
    end
  end
end

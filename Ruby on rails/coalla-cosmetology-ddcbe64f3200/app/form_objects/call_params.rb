class CallParams
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::MassAssignment
  include ActiveAttr::TypecastedAttributes

  attribute :phone
  attribute :name
  attribute :site
  attribute :utm_source
  attribute :utm_medium
  attribute :utm_campaign
  attribute :utm_content
  attribute :utm_term
  attr_accessor :validate

  with_options presence: true do
    validates :phone,
              format: { with: /\A[+|\d]\d*\z/, allow_blank: true },
              length: { maximum: 15, minimum: 6, allow_blank: true }
    validates :name, if: :validate
  end

  def phone=(value)
    value = value.gsub(/[^0-9]/, '') if value.present?
    super(value)
  end
end
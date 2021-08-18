class QuestionParams
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::MassAssignment
  include ActiveAttr::TypecastedAttributes

  attribute :email
  attribute :question
  attribute :phone
  attribute :name
  attribute :site
  attribute :utm_source
  attribute :utm_medium
  attribute :utm_campaign
  attribute :utm_content
  attribute :utm_term

  validates :email, :question, presence: true
  validates :email, format: { with: Devise.email_regexp, allow_blank: true }
  validate :question_content

  def question_content
    allowed_urls = %w(https://www.cosmeticru.com www.cosmeticru.com http://www.cosmeticru.com)
    URI.extract(question).each do |match|
      unless allowed_urls.any? { |url| match.start_with?(url) }
        errors.add(:question, I18n.t('errors.messages.third_party_links_in_question'))
        return
      end
    end
  end
end
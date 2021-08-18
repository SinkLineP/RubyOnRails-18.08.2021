# == Schema Information
#
# Table name: shops
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  code       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Shop < ActiveRecord::Base
  extend Enumerize

  has_one :pipeline, class_name: 'AmocrmPipeline'
  has_many :statuses, through: :pipeline

  enumerize :code, in: %i(cosmetic barbershop), predicates: true

  validates :title, :code, presence: true

  scope :ordered, ->() { order(:created_at) }

  class << self
    def find_by_request(request)
      domain = request.host.gsub('www.', '')
      all.detect { |shop| shop.domain == domain }
    end

    def find_by_request_or_default(request)
      find_by_request(request) || default_shop
    end

    def default_shop
      ordered.first
    end

    def barbershop
      find_by(code: :barbershop)
    end

    def cosmetic
      find_by(code: :cosmetic)
    end
  end

  def amocrm_primary_treatment_status
    statuses.primary_treatment_statuses.first
  end

  def domain
    Rails.application.secrets.shops_domains[code.to_s]
  end
end

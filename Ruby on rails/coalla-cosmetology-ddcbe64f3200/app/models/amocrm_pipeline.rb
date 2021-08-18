# == Schema Information
#
# Table name: amocrm_pipelines
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  amocrm_id  :text             not null
#  shop_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_amocrm_pipelines_on_shop_id  (shop_id)
#

class AmocrmPipeline < ActiveRecord::Base
  FOR_SALE = 589968
  RES_COSMETIC = 1355868
  RES_BARBERSHOP = 1368582
  COSMETIC = 1349100
  BARBERSHOP = 1355847
  MODULES = 1173379
  SERVICES = 3153186 #Воронка сервиса

  belongs_to :shop
  has_many :statuses, class_name: 'AmocrmStatus', inverse_of: :pipeline, dependent: :destroy

  class << self
    def resuscitation
      [RES_COSMETIC, RES_BARBERSHOP]
    end

    def sale_pipelines
      [FOR_SALE, COSMETIC, BARBERSHOP]
    end

    def modules_pipeline
      find_by(amocrm_id: MODULES)
    end

    def services_pipeline
      find_by(amocrm_id: SERVICES)
    end

    def modules_primary_treatment_status
      modules_pipeline.statuses.primary_treatment_statuses.first
    end
  end
end

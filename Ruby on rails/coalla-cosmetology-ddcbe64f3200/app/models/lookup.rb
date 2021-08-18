# == Schema Information
#
# Table name: lookups
#
#  id         :integer          not null, primary key
#  code       :text             not null
#  value      :text
#  type_code  :text             not null
#  created_at :datetime
#  updated_at :datetime
#  pdf        :text
#  pdf_status :text
#  category   :string
#  file       :text
#  shop_id    :integer
#  url        :text
#
# Indexes
#
#  index_lookups_on_code_and_shop_id  (code,shop_id) UNIQUE
#  index_lookups_on_shop_id           (shop_id)
#  index_lookups_on_type_code         (type_code)
#

class Lookup < ActiveRecord::Base
  extend Enumerize
  include Pdf

  mount_uploader :file, DownloadFileUploader

  scope :ordered, -> { order(:created_at) }
  scope :our_advantages, -> { where(category: :our_advantages) }
  scope :about, -> { where(category: :about) }
  scope :socials, -> { where(category: :socials) }

  validates :code, presence: true
  validates :value, presence: true, if: :our_advantage?

  class << self
    def configurator
      find_by(code: 'configurator')
    end
  end

  def display_value
    value.to_s.truncate(70)
  end

  def our_advantage?
    category == 'our_advantages'
  end

  def file_type?
    type_code == 'file'
  end

  def string_type?
    type_code == 'string'
  end
end

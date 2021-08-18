# == Schema Information
#
# Table name: practice_bases
#
#  id                    :integer          not null, primary key
#  title                 :text             not null
#  address               :text
#  inn                   :text
#  kpp                   :text
#  account               :text
#  bik                   :text
#  bank                  :text
#  correspondent_account :text
#  phone                 :text
#  email                 :text
#  medical_license       :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  legal_address         :text
#

class PracticeBasis < ActiveRecord::Base
  validates_presence_of :title

  has_many :group_subscriptions, dependent: :nullify, inverse_of: :practice_basis

  mount_uploader :medical_license, PrivateFileUploader

  scope :ordered, ->() { order(:created_at) }

  def medical_license_filename
    medical_license.try(:file).try(:filename)
  end
end

# == Schema Information
#
# Table name: recalls
#
#  id           :integer          not null, primary key
#  file         :text
#  video_link   :text
#  message      :text             not null
#  author_name  :text             not null
#  author_image :text
#  created_at   :datetime
#  updated_at   :datetime
#  video_image  :text
#  show_on_main :boolean          default(FALSE), not null
#  directions   :text
#  lock_on_top  :boolean          default(FALSE)
#  shop_id      :integer
#
# Indexes
#
#  index_recalls_on_shop_id  (shop_id)
#

class Recall < ActiveRecord::Base
  include WithUploadedVideo
  extend Enumerize
  COURSE_SHOP_DIRECTIONS = %i(cosmetology massage makeup management online_education)
  BARBERSHOP_DIRECTIONS = %i(base_learning training barbershop_online_education)

  has_many :course_recalls, dependent: :destroy, inverse_of: :recall
  has_many :courses, -> { uniq }, through: :course_recalls

  with_uploaded_video

  serialize :directions, Array
  enumerize :directions, in: COURSE_SHOP_DIRECTIONS + BARBERSHOP_DIRECTIONS, multiple: true

  mount_uploader :file, RecallFileUploader
  mount_uploader :author_image, RecallAuthorImageUploader
  mount_uploader :video_image, RecallVideoImageUploader

  with_options presence: true do
    validates :message
    validates :author_name
  end
  validates :video_image, presence: { message: :not_loaded }, if: 'video_link.present?'

  scope :alphabetical_order, -> { order(:message) }
  scope :locktop, -> { order(lock_on_top: :desc) }
  scope :ordered, -> { order(:created_at) }
  scope :ordered_desc, -> { locktop.order(created_at: :desc) }
  scope :for_main, -> { where(show_on_main: true) }
  scope :with_direction, ->(direction) { where("directions ILIKE '%#{direction}%'") }

  def video_link=(value)
    super(value)
    return if value.blank? || video_image.present?
    url = VideoThumb::get(value, 'large')
    self.remote_video_image_url = url if url
  end

  # for correct ordering
  # TODO (vl): refactor this
  def course_ids=(course_ids = [])
    course_ids.each_with_index do |id, index|
      course_recalls.find_by(course_id: id).try(:update_column, :position, index + 1)
    end
    super
  end
end

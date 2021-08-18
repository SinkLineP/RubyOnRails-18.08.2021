module WithUploadedVideo
  extend ActiveSupport::Concern

  class_methods do
    def with_uploaded_video
      has_one :item_video, as: :item, dependent: :destroy
      has_one :uploaded_video, through: :item_video

      delegate :id, to: :uploaded_video, allow_nil: true, prefix: true

      accepts_nested_attributes_for :item_video,
                                    allow_destroy: true,
                                    reject_if: ->(attrs) { attrs['uploaded_video_id'].blank? && attrs['id'].blank? }
    end
  end

  def uploaded_video_id=(value)
    attrs = { uploaded_video_id: value }
    attrs[:id] = item_video.try(:id) if item_video.try(:id)
    self.item_video_attributes = attrs
  end
end

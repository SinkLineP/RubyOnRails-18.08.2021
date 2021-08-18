# Контроллер раздела "Награды"
# @see AbstractImagesController
# @see app/views/admin/abstract_images
module Admin
  class RewardImagesController < AbstractImagesController
    def model
      RewardImage
    end

    def redirect_url
      admin_reward_images_path
    end
  end
end
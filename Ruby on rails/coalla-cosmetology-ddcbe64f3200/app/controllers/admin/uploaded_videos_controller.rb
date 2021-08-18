# Контроллер раздела "Видео"
# @see app/views/admin/uploaded_videos
module Admin
  class UploadedVideosController < AdminController
    load_and_authorize_resource

    def index
      @uploaded_videos = UploadedVideo.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @uploaded_video = UploadedVideo.new
    end

    def create
      @uploaded_video = UploadedVideo.new(uploaded_video_params)
      save_and_responce
    end

    def update
      @uploaded_video.assign_attributes(uploaded_video_params)
      save_and_responce
    end

    def destroy
      @uploaded_video.destroy
      redirect_to admin_uploaded_videos_path
    end

    def list
      videos = UploadedVideo.ordered.where('title ilike ?', "%#{params[:term]}%").first(50).to_a
      videos_json = videos.map do |video|
        {
          id: video.id,
          label: ['Загруженное видео', video.title].join(' | '),
          imageUrl: video.preview_image.url(:main),
          type: video.model_name.to_s
        }
      end
      render json: videos_json
    end

    protected

    def save_and_responce
      if @uploaded_video.save
        redirect_to edit_admin_uploaded_video_path(@uploaded_video)
        return
      end

      render :edit
    end

    def uploaded_video_params
      params.require(:uploaded_video).permit!
    end
  end
end
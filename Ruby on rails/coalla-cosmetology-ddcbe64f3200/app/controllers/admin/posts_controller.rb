# Контроллер раздела "Блог"
# @see app/views/admin/posts
module Admin
  class PostsController < AdminController
    before_action except: [:index, :new, :create] do
      @post = Post.find(params[:id])
      force_update_current_shop_id(@post.shop_id)
    end

    authorize_resource

    set_current_shop_for_model(Post)

    before_action only: [:new, :create] do
      @post = Post.new
    end

    def index
      @posts = Post.admin_ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
    end

    def create
      @post.assign_attributes(params[:post].permit!)
      apply_commit_action
    end

    def edit
    end

    def update
      @post.assign_attributes(params[:post].permit!)
      apply_commit_action
    end

    private

    def save
      save_and_redirect_or_render
    end

    def publish
      @post.publish if @post.valid?
      save_and_redirect_or_render
    end

    def withdraw
      @post.withdraw if @post.valid?
      save_and_redirect_or_render
    end

    def preview
      @post.created_at = Time.now
      render 'posts/show', layout: 'user'
    end

    def save_and_redirect_or_render
      if @post.save
        redirect_to edit_admin_post_path(@post)
      else
        render(@post.new_record? ? :new : :edit)
      end
    end
  end
end
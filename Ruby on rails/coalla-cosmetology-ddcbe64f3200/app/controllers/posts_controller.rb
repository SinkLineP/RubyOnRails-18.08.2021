class PostsController < ApplicationController

  PER_PAGE = 9

  def index
    redirect_to blog_path and return unless load_posts
    load_slides
    set_title(['Дом Русской Косметики', 'Блог'])
    render 'posts/index'
  end

  def show
    @post = Post.find(params[:id])
    impressionist(@post)
    set_title(['Дом Русской Косметики', 'Блог', @post.title])
  end

  private

  def load_posts
    @categories = PostCategory.with_posts.ordered_by_title
    @category = PostCategory.find(params[:category_id]) if params[:category_id].present?

    posts_scope = @category.try(:posts) || Post
    @filter = params['filter'].presence || 'newest'
    return false unless Post::FILTER_VALUES.include?(@filter)
    @posts = posts_scope.published.send(@filter).paginate(page: params[:page], per_page: PER_PAGE)
    return true
  end

  def load_slides
    @slides = Post.slides
  end
end
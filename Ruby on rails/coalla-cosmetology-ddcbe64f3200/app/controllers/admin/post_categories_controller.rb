# Категории постов
# @see app/assets/javascripts/admin/posts.js.coffee
module Admin
  class PostCategoriesController < AdminController
    LIMIT = 5

    def index
      post_categories = PostCategory.ordered_by_title
      post_categories = post_categories.where('title ilike ?', "#{params[:term]}%") if params[:term].present?

      render json: post_categories.first(LIMIT).map { |company| { value: company.name } }
    end
  end
end
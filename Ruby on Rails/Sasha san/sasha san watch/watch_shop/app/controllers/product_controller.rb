class ProductController < ApplicationController
  before_action :set_page_options

  attr_accessor :product
  def show
    @product=Product.find(params[:id] )
  end

  def set_page_options
    set_meta_tags product.slice(:title, :keywords, :description)
    add_breadcrumb name: 'Home', path :root_path, title: 'Home'
  end

end



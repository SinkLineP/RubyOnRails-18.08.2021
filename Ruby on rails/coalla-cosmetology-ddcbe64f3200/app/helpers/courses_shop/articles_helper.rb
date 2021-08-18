module CoursesShop
  module ArticlesHelper

    def all_articles_url(article)
      if article.blog?
        courses_shop_blogs_path
      elsif article.mass_media?
        courses_shop_mass_media_section_index_path
      elsif article.science_and_drk?
        courses_shop_science_and_drks_path
      else
        courses_shop_root_path
      end
    end

    def current_article_url(article)
      if article.blog?
        courses_shop_blog_url(article)
      elsif article.mass_media?
        courses_shop_mass_media_section_url(article)
      elsif article.science_and_drk?
        courses_shop_science_and_drk_url(article)
      else
        courses_shop_root_url
      end
    end

  end
end
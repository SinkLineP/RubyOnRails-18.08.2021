Shop.all.each do |shop|
  SitemapGenerator::Interpreter.send :include, CoursesShop::AlternativeUrlsHelper
  SitemapGenerator::Sitemap.default_host = "https://www.#{shop.domain}"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{shop.code}"
  SitemapGenerator::Sitemap.namer = SitemapGenerator::SimpleNamer.new(:sitemap, :extension => '.xml')
  SitemapGenerator::Sitemap.adapter = Class.new(SitemapGenerator::FileAdapter) {
    def gzip(stream, data)
      stream.write(data)
      stream.close
    end
  }.new

  SitemapGenerator::Sitemap.create do
    [
      courses_shop_blogs_path,
      courses_shop_recalls_path,
      courses_shop_faqs_path,
      courses_shop_science_and_drks_path,
      courses_shop_mass_media_section_index_path,
      courses_shop_institution_blocks_path,
      courses_shop_history_path,
      courses_shop_about_partners_path,
      courses_shop_diploma_path,
      courses_shop_teachers_path,
      courses_shop_tour_path,
      courses_shop_graduates_path,
      courses_shop_cecutient_version_path,
      courses_shop_contacts_path,
      courses_shop_license_path,
      courses_shop_offer_path,
      courses_shop_models_path,
      courses_shop_promotions_path,
      courses_shop_consulting_path,
      courses_shop_partners_path,
      courses_shop_regional_schools_path,
      courses_shop_manufacturers_and_dealers_path,
      courses_shop_mass_media_path,
      courses_shop_corporate_education_path,
      courses_shop_recruitment_path,
      courses_shop_privacy_policy_path
    ].each do |path|
      add path, priority: 0.7
    end

    Blog.all.where(shop_id: shop.id).each do |blog|
      add courses_shop_blog_path(blog), priority: 0.7
    end

    ScienceAndDrk.all.where(shop_id: shop.id).each do |article|
      add courses_shop_science_and_drk_path(article), priority: 0.7
    end

    MassMedia.all.where(shop_id: shop.id).each do |article|
      add courses_shop_mass_media_section_path(article), priority: 0.7
    end

    Speciality.all.where(shop_id: shop.id).each do |speciality|
      add alternative_speciality_url(speciality, only_path: true), priority: 0.7

      next unless speciality.root?

      speciality.all_courses.each do |course|
        add alternative_course_url(course, speciality, only_path: true), priority: 0.7
      end
    end
  end
end
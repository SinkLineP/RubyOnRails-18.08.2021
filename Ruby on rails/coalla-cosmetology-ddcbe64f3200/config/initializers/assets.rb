# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( admin/admin.css courses_shop/application.js courses_shop/application.css sikorsky_school/components/_group_places.css)
Rails.application.config.assets.precompile += [->(path) {
  full_path = Rails.application.assets.resolve(path)
  File.extname(full_path).in?(%w(.js .css .coffee))
}]

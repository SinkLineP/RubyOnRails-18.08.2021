class AddDataToSpecialities < ActiveRecord::Migration
  def change
    SiteMetaTags.create!(identifier: '/science_and_drks', title: 'Научные публикации')
  end
end

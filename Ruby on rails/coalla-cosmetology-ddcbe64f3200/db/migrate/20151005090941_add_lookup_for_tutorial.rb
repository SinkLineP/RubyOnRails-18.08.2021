class AddLookupForTutorial < ActiveRecord::Migration
  def up
    Lookup.create!(code: :tutorial, value: '<iframe src="//www.slideshare.net/slideshow/embed_code/key/eMbIdhn7JYu0j5" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe>', type_code: :string)
  end

  def down
    Lookup.where(code: :tutorial).delete_all
  end
end

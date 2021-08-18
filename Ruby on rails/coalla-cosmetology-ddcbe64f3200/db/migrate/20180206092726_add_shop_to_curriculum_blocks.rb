class AddShopToCurriculumBlocks < ActiveRecord::Migration
  def up
    if !column_exists?(:curriculum_blocks, :shop_id)
      add_reference :curriculum_blocks, :shop, index: true, foreign_key: true
      courses_shop = Shop.cosmetic
      CurriculumBlock.update_all(shop_id: courses_shop.id)
    end
  end

  def down
  end
end

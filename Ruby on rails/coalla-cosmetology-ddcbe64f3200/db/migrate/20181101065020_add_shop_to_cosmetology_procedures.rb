class AddShopToCosmetologyProcedures < ActiveRecord::Migration
  def up
    add_reference :cosmetology_procedures, :shop, index: true, foreign_key: true
    courses_shop = Shop.cosmetic
    CosmetologyProcedure.update_all(shop_id: courses_shop.id)

    [
        'Мужские стрижки',
        'Оформление бороды',
        'Женские стрижки',
        'Окрашивание волос'
    ].each do |procedure_name|
      CosmetologyProcedure.create!(name: procedure_name, shop_id: Shop.barbershop.id)
    end
  end

  def down
    remove_column :cosmetology_procedures, :shop
  end
end

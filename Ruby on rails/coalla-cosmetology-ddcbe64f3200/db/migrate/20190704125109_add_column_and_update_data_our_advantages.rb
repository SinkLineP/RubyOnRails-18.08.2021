class AddColumnAndUpdateDataOurAdvantages < ActiveRecord::Migration
  def change
    add_column :lookups, :url, :text

    Lookup.find_by(code: :graduate, shop_id: 1)
          .update(url: '/info#final_documents',
                  value: 'Работаем с 1989 года.<br/>Выдаем дипломы государственного образца')

    Lookup.find_by(code: :documentation, shop_id: 1)
          .update(code: 'percent', url: '',
                  value: 'Рассрочка на 24 месяца без переплат')

    Lookup.find_by(code: :diploma, shop_id: 1)
          .update(url: '/about/diploma')

    Lookup.find_by(code: :diploma, shop_id: 2)
          .update(url: '/about/diploma')
  end
end

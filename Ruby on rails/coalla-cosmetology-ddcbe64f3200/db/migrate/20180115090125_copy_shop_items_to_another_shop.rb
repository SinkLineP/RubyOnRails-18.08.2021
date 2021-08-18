class CopyShopItemsToAnotherShop < ActiveRecord::Migration
  def up
    courses_shop = Shop.create!(title: 'Дом Русской Косметики', code: :cosmetic)
    barbershop = Shop.create!(title: 'Парикмахерская Академия', code: :barbershop)

    remove_index :lookups, :code
    remove_index :meta_tags, :identifier
    add_index :lookups, [:code, :shop_id], unique: true
    add_index :meta_tags, [:identifier, :shop_id], unique: true

    SharedModels::CLASSES.each do |_class|
      _class.update_all(shop_id: courses_shop.id)
    end

    [
      Lookup.where('category != ? OR category IS NULL', 'our_advantages').to_a,
      HtmlItem.all.to_a,
      SiteMetaTags.all.to_a
    ].each do |scope_model|
      scope_model.each do |model_item|
        new_model_item = model_item.deep_dup
        new_model_item.shop_id = barbershop.id
        new_model_item.save!
      end
    end

    {
      model_practice: 'Максимум практики - постановка руки и отработка на моделях',
      modern_techniques: 'Только современные востребованные техники стрижки и окрашивания',
      diploma: 'Выдаем международный диплом позволяющий работать в 42 странах мира',
      employment: 'Трудоустройство выпускников среди работодателей - более 100 барбершопов и салонов красоты',
      teachers: 'Опытные преподаватели-практики',
      internet: 'Система дистанционного обучения позволяет изучить теорию через Интернет'
    }.each do |code, value|
      Lookup.create!(code: code,
                     value: value,
                     type_code: 'memo',
                     category: 'our_advantages',
                     shop_id: barbershop.id)
    end

    ['Наши новости', 'Новости индустрии'].each do |category_name|
      Category.create!(name: category_name, shop_id: barbershop.id)
    end

    root_speciality = Speciality.create!(title: 'Обучение с нуля',
                                         shop_id: barbershop.id,
                                         genitive_form: 'Курсы обучения с нуля парикмахеров и барберов',
                                         icon: 'pupil')
    ['Обучение парикмахеров', 'Обучение барберов'].each do |sub_speciality_name|
      Speciality.create!(title: sub_speciality_name, parent_id: root_speciality.id, shop_id: barbershop.id)
    end

    root_speciality = Speciality.create!(title: 'Повышение квалификации',
                                         shop_id: barbershop.id,
                                         genitive_form: 'Курсы повышения квалификации',
                                         icon: 'crown')
    ['Мужские стрижки и бритье', 'Женские стрижки', 'Колористика', 'Прически'].each do |sub_speciality_name|
      Speciality.create!(title: sub_speciality_name, parent_id: root_speciality.id, shop_id: barbershop.id)
    end

  end

  def down
    barbershop = Shop.find_by(code: :barbershop)

    remove_index :lookups, [:code, :shop_id]
    remove_index :meta_tags, [:identifier, :shop_id]

    [
      Lookup,
      SiteMetaTags,
      HtmlItem,
      Faculty,
      Category,
      Speciality
    ].each do |scope_model|
      scope_model.where(shop_id: barbershop.id).destroy_all if barbershop
    end

    SharedModels::CLASSES.each do |scope_model|
      scope_model.update_all(shop_id: nil)
    end

    add_index :lookups, :code, unique: true
    add_index :meta_tags, :identifier, unique: true

    Shop.delete_all
  end
end

class CreateCosmetologyProcedures < ActiveRecord::Migration
  def up
    create_table :cosmetology_procedures do |t|
      t.text :name

      t.timestamps null: false
    end


    [
        'Мезотерапия/биоревитализация',
        'Введение ботулотоксина А',
        'Контурная пластика носогубной складки',
        'Макияж',
        'Уход за лицом и телом',
        'Мезонити',
        'Введение Диспорт',
        'Перманентный макияж',
        'Химический пилинг',
        'Архитектура бровей',
        'Ламинирование/наращивание ресниц',
        'Склеротерапия',
        'Трихология',
        'Аппаратная косметология'
    ].each do |procedure_name|
      CosmetologyProcedure.create!(name: procedure_name)
    end
  end

  def down
    drop_table :cosmetology_procedures
  end
end

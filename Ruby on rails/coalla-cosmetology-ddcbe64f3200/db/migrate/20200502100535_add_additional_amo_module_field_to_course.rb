class AddAdditionalAmoModuleFieldToCourse < ActiveRecord::Migration
  def change
    add_reference :courses, :additional_amo_module, index: true
    add_foreign_key :courses, :amo_modules, column: :additional_amo_module_id
  end
end

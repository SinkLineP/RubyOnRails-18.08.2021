class RenameManagementSpeciality < ActiveRecord::Migration
  def up
    Speciality.find(15).update_attributes(title: "Салонам и клиникам", slug: "kursy-salonam-i-klinikam", genitive_form: "Салонам и клиникам")
  end

  def down
    Speciality.find(15).update_attributes(title: "Менеджмент", slug: "kursy-management", genitive_form: "Курсы менеджмента")
  end
end

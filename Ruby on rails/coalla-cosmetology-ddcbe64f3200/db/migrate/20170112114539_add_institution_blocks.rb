class AddInstitutionBlocks < ActiveRecord::Migration

  def up
    %w(requisites charter founders controls licenses final_documents contract_for_education_services rates_for_education_services self_report expenditure_report logistics_process).each do |code|
      InstitutionBlock.create!(code: code)
    end
  end

  def down
    InstitutionBlock.destroy_all
  end
end

module Amocrm
  class FullImport
    def run
      errors = {}

      [
          Import::Students,
          Import::GroupSubscriptions,
          Import::Notes
      ].each do |step|
        begin
          step_errors = step.new.run
          errors.merge!(step_errors)
        rescue => ex
          errors[step] = ex
        end
      end

      errors
    end
  end
end
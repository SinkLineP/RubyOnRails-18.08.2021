# == Schema Information
#
# Table name: amocrm_imports
#
#  id            :integer          not null, primary key
#  completed     :boolean          default(FALSE), not null
#  completed_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  job_id        :integer
#  errors_string :text
#

class AmocrmImport < ActiveRecord::Base
  def self.last_completed
    where(completed: true).order(:completed_at).last
  end

  def self.enqueue!
    import = create!
    Delayed::Job.enqueue(AmocrmImportJob.new(import.id))
  end
end

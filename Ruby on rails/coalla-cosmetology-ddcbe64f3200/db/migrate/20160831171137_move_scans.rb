class MoveScans < ActiveRecord::Migration
  def up
    WorkResult.where.not(scan: nil).find_each do |work_result|
      scan_path = File.join(Rails.root,
                            'private',
                            'uploads',
                            work_result.class.name.underscore,
                            'scan',
                            work_result.id.to_s,
                            work_result.scan)
      next unless File.exists?(scan_path)
      work_result.scans.create!(file: File.open(scan_path))
    end
  end

  def down
  end
end

class RecalculateGroupCounters < ActiveRecord::Migration
  def change
    Group.find_each do |group|
      group.recalculate_counters
    end
  end
end

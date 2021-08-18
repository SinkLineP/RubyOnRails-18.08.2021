class AddNoticeEmailsToNoticeGroups < ActiveRecord::Migration
  def change
    add_column :notices, :notice_emails, :text, array: true, default: []
  end
end

class CreateMailingJournals < ActiveRecord::Migration
  def change
    create_table :mailing_journals do |t|
      t.string :mailing_title
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :mailing_journals, :mailing_title
  end
end

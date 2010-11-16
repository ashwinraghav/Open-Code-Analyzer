class AddingCodeSubId < ActiveRecord::Migration
  def self.up
    add_column :code_submissions, :reviewed_code_submission_id, :integer
  end

  def self.down
    remove_column :code_submissions, :reviewed_code_submission_id
  end
end

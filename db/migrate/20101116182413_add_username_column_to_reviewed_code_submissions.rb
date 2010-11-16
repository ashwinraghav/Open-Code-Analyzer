class AddUsernameColumnToReviewedCodeSubmissions < ActiveRecord::Migration
  def self.up
    add_column :reviewed_code_submissions, :user, :string
  end

  def self.down
    remove_column :reviewed_code_submissions, :user
  end
end

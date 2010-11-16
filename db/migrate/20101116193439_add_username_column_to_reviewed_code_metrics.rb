class AddUsernameColumnToReviewedCodeMetrics < ActiveRecord::Migration
  def self.up
    add_column :reviewed_code_metrics, :user, :string
  end

  def self.down
    remove_column :reviewed_code_metrics, :user
  end
end

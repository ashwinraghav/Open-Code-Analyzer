class AddPursueColumn < ActiveRecord::Migration
  def self.up
    add_column :reviewed_code_submissions, :pursued, :boolean
  end

  def self.down
    remove_column :reviewed_code_submissions, :pursued
  end
end

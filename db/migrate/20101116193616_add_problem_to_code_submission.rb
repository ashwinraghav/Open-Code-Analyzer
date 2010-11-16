class AddProblemToCodeSubmission < ActiveRecord::Migration
  def self.up
    add_column :code_submissions, :problem, :string
  end

  def self.down
    remove_column :code_submissions, :problem, :string
  end
end

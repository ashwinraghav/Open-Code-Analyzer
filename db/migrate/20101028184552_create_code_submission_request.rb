class CreateCodeSubmissionRequest < ActiveRecord::Migration
  
  def self.up
    create_table :code_submissions do |t|
    end
  end

  def self.down
    drop_table :code_submissions 
  end
end

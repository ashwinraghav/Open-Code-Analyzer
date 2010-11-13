class CreateReviewedCodeSubmission < ActiveRecord::Migration
  def self.up
    create_table :reviewed_code_submissions do |t|
      t.integer :number_of_classes
      t.integer :number_of_methods
      t.integer :lines_of_code
      t.integer :total_cyclomatic_complexity
      t.integer :max_cyclomatic_complexity
      t.integer :rating
      t.string :problem
    end
  end

  def self.down
    drop_table :reviewed_code_submissions
  end
end

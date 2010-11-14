class CreateReviewedCodeMetricsTable < ActiveRecord::Migration
  def self.up
    create_table :reviewed_code_metrics do |t|
      t.string :problem
      t.string :category
      
      t.float :mean_max_complexity
      t.float :var_max_complexity
      
      t.float :mean_no_of_methods
      t.float :var_no_of_methods
      
      t.float :mean_total_cyclomatic_complexity
      t.float :var_total_cyclomatic_complexity
      
      t.float :mean_no_of_classes
      t.float :var_no_of_classes

      t.float :mean_lines_of_code
      t.float :var_lines_of_code
    end
  end

  def self.down
  end
end

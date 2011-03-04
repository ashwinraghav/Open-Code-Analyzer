require 'csv'

#Destroy the Reviewed Code metrics and recreate it from existing data
@users = ReviewedCodeSubmission.find_by_sql("select distinct(user) from reviewed_code_submissions")

CodeProblems.destroy_all

def load_data(metrics, category, problem, u)
  reviewed_code_metrics = CodeProblems.new(:problem => problem, :category => category, :user => u.user)

  reviewed_code_metrics.mean_max_complexity = metrics["max_cyclomatic_complexity"].mean

  reviewed_code_metrics.var_max_complexity = metrics["max_cyclomatic_complexity"].sample_variance
  reviewed_code_metrics.mean_lines_of_code = metrics["lines_of_code"].mean
  reviewed_code_metrics.var_lines_of_code = metrics["lines_of_code"].sample_variance
  reviewed_code_metrics.mean_no_of_methods = metrics["number_of_methods"].mean

  reviewed_code_metrics.var_no_of_methods = metrics["number_of_methods"].sample_variance
  reviewed_code_metrics.mean_no_of_classes = metrics["number_of_classes"].mean
  reviewed_code_metrics.var_no_of_classes = metrics["number_of_classes"].sample_variance
  reviewed_code_metrics.mean_total_cyclomatic_complexity = metrics["total_cyclomatic_complexity"].mean
  reviewed_code_metrics.var_total_cyclomatic_complexity = metrics["total_cyclomatic_complexity"].sample_variance
  reviewed_code_metrics.save
end

@users.each do |u|
  ["Mars Rover", "Sales Tax"].each do |problem|
    puts "here"
    below_average_training_set = TrainingDataSet.new(:below_average)
    average_training_set = TrainingDataSet.new(:average)
    above_average_training_set = TrainingDataSet.new(:above_average)

    below_average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 1, :user => u.user})
    average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 2, :user => u.user})
    above_average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 3, :user => u.user})

    below_average.each { |r| below_average_training_set.add r }
    average.each { |r| average_training_set.add r }
    above_average.each { |r| above_average_training_set.add r }
    training_sets = {"average" => average_training_set, "below_average" => below_average_training_set, "above_average" => above_average_training_set}

    %w{ average below_average above_average }.each do |category|
      metrics = training_sets[category].metrics
      load_data(metrics,category, problem, u) unless metrics.blank?
    end
  end
end

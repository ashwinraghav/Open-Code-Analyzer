require 'csv'

mars_rover_file = CSV.read('db/cleaned_up_mars_rover_seed_data.csv')
mars_rover_file.shift
mars_rover_file.shift

mars_rover_file.each do |row|
  ReviewedCodeSubmission.new({:number_of_classes            => row[1],
                              :number_of_methods            => row[2],
                              :lines_of_code                => row[3],
                              :total_cyclomatic_complexity  => row[4],
                              :max_cyclomatic_complexity    => row[5],
                              :rating                       => row[6],
                              :problem                      => "Mars Rover"}).save
end

sales_tax_file = CSV.read('db/cleaned_up_tax_seed_data.csv')
sales_tax_file.shift
sales_tax_file.shift

sales_tax_file.each do |row|
  ReviewedCodeSubmission.new({:number_of_classes            => row[1],
                              :number_of_methods            => row[2],
                              :lines_of_code                => row[3],
                              :total_cyclomatic_complexity  => row[4],
                              :max_cyclomatic_complexity    => row[5],
                              :rating                       => row[6],
                              :problem                      => "Sales Tax"}).save
end

below_average_training_set = TrainingDataSet.new(:below_average)
average_training_set = TrainingDataSet.new(:average)
above_average_training_set = TrainingDataSet.new(:above_average)

below_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 1 }
average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 2 }
above_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 3 }

below_average.each { |r| below_average_training_set.add r if r.id % 2 == 0 }
average.each { |r| average_training_set.add r if r.id % 2 == 0 }
above_average.each { |r| above_average_training_set.add r if r.id % 2 == 0 }

training_sets = {"average" => average_training_set, "below_average" => below_average_training_set, "above_average" => above_average_training_set }

%w{average below_average above_average}.each do |category|
  reviewed_code_metrics = ReviewedCodeMetrics.new(:problem => "Mars Rover", :category => category.to_sym)
  metrics = training_sets[category].metrics
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

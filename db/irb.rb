#awk -f cleanup_data.awk seed_data.csv > cleaned_up_seed_data.csv

require 'models/mixins/statistics.rb'
require 'services/bayes.rb'
require 'services/metric.rb'
require 'services/training_data_set.rb'
require 'services/training_data_point.rb'

below_average_training_set = TrainingDataSet.new(:below_average)
average_training_set = TrainingDataSet.new(:average)
above_average_training_set = TrainingDataSet.new(:above_average)

below_average = ReviewedCodeSubmission.find_all_by_problem("Sales Tax").find_all { |r| r.rating == 1 }
average = ReviewedCodeSubmission.find_all_by_problem("Sales Tax").find_all { |r| r.rating == 2 }
above_average = ReviewedCodeSubmission.find_all_by_problem("Sales Tax").find_all { |r| r.rating == 3 }

below_average.each  { |r| below_average_training_set.add r  if r.id % 2 == 0 }
average.each        { |r| average_training_set.add r        if r.id % 2 == 0 }
above_average.each  { |r| above_average_training_set.add r  if r.id % 2 == 0 }

bayes = Bayes.new
bayes.train(:below_average, below_average_training_set.metrics)
bayes.train(:average, average_training_set.metrics)
bayes.train(:above_average, above_average_training_set.metrics)

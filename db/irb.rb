#awk -f cleanup_data.awk seed_data.csv > cleaned_up_seed_data.csv

below_average_training_set = TrainingDataSet.new(:below_average)
average_training_set = TrainingDataSet.new(:average)
above_average_training_set = TrainingDataSet.new(:above_average)

below_average = ReviewedCodeSubmission.all.find_all { |r| r.rating == 1 }
average = ReviewedCodeSubmission.all.find_all { |r| r.rating == 2 }
above_average = ReviewedCodeSubmission.all.find_all { |r| r.rating == 3 }

below_average.each_with_index  { |r, i| below_average_training_set.add r  if i % 2 == 0 }
average.each_with_index        { |r, i| average_training_set.add r        if i % 2 == 0 }
above_average.each_with_index  { |r, i| above_average_training_set.add r  if i % 2 == 0 }

bayes = Bayes.new
bayes.train(:below_average, below_average_training_set.metrics)
bayes.train(:average, average_training_set.metrics)
bayes.train(:above_average, above_average_training_set.metrics)

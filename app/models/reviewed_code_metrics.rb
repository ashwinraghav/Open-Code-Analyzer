class ReviewedCodeMetrics
  class << self
    def find_by_category_and_problem(category, problem)
      below_average_training_set = TrainingDataSet.new(:below_average)
      average_training_set = TrainingDataSet.new(:average)
      above_average_training_set = TrainingDataSet.new(:above_average)

      below_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 1 }
      average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 2 }
      above_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 3 }

      below_average.each { |r| below_average_training_set.add r if r.id % 2 == 0 }
      average.each { |r| average_training_set.add r if r.id % 2 == 0 }
      above_average.each { |r| above_average_training_set.add r if r.id % 2 == 0 }

      if category == :below_average
        below_average_training_set.metrics
      elsif category == :average
        average_training_set.metrics
      else
        above_average_training_set.metrics
      end
    end
  end
end

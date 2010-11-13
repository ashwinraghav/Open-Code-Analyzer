class ReviewedCodeMetrics
  class << self
    def find_by_category_and_problem(category, problem)
    below_average_training_set = TrainingDataSet.new(:below_average)
    below_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 1 }
    below_average.each { |r| below_average_training_set.add r if r.id % 2 == 0 }
    below_average_training_set.metrics
    end
  end
end

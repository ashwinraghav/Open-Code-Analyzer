class TrainingDataSet
  include Statistics

  def initialize(category)
    @category = category
  end

  def add(reviewed_code_submission)
    reviewed_code_submissions << reviewed_code_submission
  end

  def metrics
    metric_plus_values = reviewed_code_submissions.find_all(&:has_code?).map(&:metrics).inject({}) do |result, metrics|
      metrics.entries.each do |metric_name, value|
        (result[metric_name] ||= []) << value
      end
      result
    end

    metric_plus_values.entries.inject({}) do |result, (metric, values)|
      mean = mean(values)
      result[metric] = Metric.new(metric, mean, sample_variance(values, mean))
      result
    end
  end

  def reviewed_code_submissions
    @reviewed_code_submissions ||= []
  end
end
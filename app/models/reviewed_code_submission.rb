class ReviewedCodeSubmission < ActiveRecord::Base
  METRICS = ["number_of_classes", "number_of_methods", "lines_of_code", "total_cyclomatic_complexity", "max_cyclomatic_complexity"]

  def metrics
    METRICS.inject({}) { |hash, metric_name| hash[metric_name] = self.send(metric_name); hash }
  end

  def has_code?
    lines_of_code > 0
  end
  
end
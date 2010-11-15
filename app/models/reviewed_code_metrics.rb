class ReviewedCodeMetrics < ActiveRecord::Base
  set_table_name "reviewed_code_metrics"

  def name
    self.category.sub(/_/, " ").capitalize
  end

  def metrics
    { "max_cyclomatic_complexity" => Metric.new("max_cyclomatic_complexity",self.mean_max_complexity, self.var_max_complexity),
      "lines_of_code" => Metric.new("lines_of_code",self.mean_lines_of_code, self.var_lines_of_code), 
      "number_of_methods" => Metric.new("number_of_methods",self.mean_no_of_methods, self.var_no_of_methods),
      "number_of_classes" => Metric.new("number_of_classes",self.mean_no_of_classes, self.var_no_of_classes),
      "total_cyclomatic_complexity" => Metric.new("total_cyclomatic_complexity",self.mean_total_cyclomatic_complexity, self.var_total_cyclomatic_complexity)    }
  end
end

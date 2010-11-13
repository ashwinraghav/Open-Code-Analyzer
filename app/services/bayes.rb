class Bayes
  include Statistics

  def train(category, metrics)
    training_data[category] = metrics
  end

  def nostradamus(value_to_predict)
    categories_with_probabilities = training_data.entries.inject({}) do |result, (category, values)|
      result[category] = value_to_predict.entries.inject({}) do |hash, (metric_name, value)|
        metric = training_data[category][metric_name]
        hash[metric_name] = probability_density_function(value, metric.mean, metric.sample_variance)
        hash
      end
      result
    end

    categories_with_probabilities.entries.inject({}) do |result, (category, values_hash)|
      result[category] = values_hash.values.inject(0.5) { |cumulative_probability, probability| cumulative_probability * probability }
      result
    end
  end

  def training_data
    @training_data ||= {}
  end
end

class Bayes
  include Statistics

  def train(category, metrics)
    training_data[category] = metrics
  end

  def nostradamus(value_to_predict)
    categories_with_probabilities = training_data.entries.inject({}) do |result, (category, values)|
      result[category] = value_to_predict.entries.inject({}) do |hash, (attribute, value)|
        hash[attribute] = probability_density_function(value, training_data[category][attribute].first, training_data[category][attribute].last)
        hash
      end
      result
    end

    categories_with_probabilities.entries.inject({}) do |result, (key, values_hash)|
      result[key] = values_hash.values.inject(0.5) { |r, v| r * v }
      result
    end
  end

  def training_data
    @training_data ||= {}
  end
end
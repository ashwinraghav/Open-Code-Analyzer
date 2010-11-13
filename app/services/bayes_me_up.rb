class TrainingData
  include Statistics

  def add(category, value)
    training_data[category] = value
  end

  alias []= add

  def get(name)
    training_data[name]
  end

  alias [] get

  def training_data
    @training_data ||= {}
  end

  def categories
    training_data.keys
  end

  def means_for(category, *attributes)
    attributes.inject({}) do |hash, attribute|
      hash[attribute] = mean(training_data[category].map { |item| item[attribute].to_f })
      hash
    end
  end
end

class BayesMeUp
  include Statistics

  #
  # b = BayesMeUp.new
  # b.train({:height => 6, :weight => 200, :foot => 10}, :male)
  # b.train({:height => 5.72, :weight => 120, :foot => 6}, :female)
  def train(training_data_point, category)
    (training_data[category] ||= []) << TrainingDataPoint.new(training_data_point)
  end

  # 
  # b = BayesMeUp.new
  # b.train({:height => 6, :weight => 200, :foot => 10}, :male)
  # b.train({:height => 5.72, :weight => 120, :foot => 6}, :female)
  # b.nostradamus({:height => 6, :weight =>130, :foot =>8}) => {:male => probability1, :female => probability2 }
  def nostradamus(value_to_predict)
    categories_with_probabilities = training_data.categories.inject({}) do |result, category|
      result[category] = value_to_predict.entries.inject({}) do |hash, (attribute, value)|
        hash[attribute] = probability_density_function(value, mean_for(category, attribute), variance_for(category, attribute))
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
    @training_data ||= TrainingData.new
  end

  private
  def mean_for(category, attribute)
    training_data.means_for(category, attribute)[attribute]
  end

  def values_for(category, attribute)
    training_data[category].map { |item| item[attribute].to_f }
  end

  def variance_for(category, attribute)
    sample_variance(values_for(category, attribute), mean_for(category, attribute))
  end
end
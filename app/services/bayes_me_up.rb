class BayesMeUp
  include Statistics

  def train(hash, category)
    (training_data[category] ||= []) << hash
  end

  def gaussianify
    mean_height = mean_for(:male, :height)
    variance_height = variance(:male, :height)
    mean_weight = mean_for(:male, :weight)
    variance_weight = variance(:male, :weight)
    mean_foot = mean_for(:male, :foot)
    variance_foot = variance(:male, :foot)

    [mean_height, variance_height, mean_weight, variance_weight, mean_foot, variance_foot]
  end

  def nostradamus(value)
    male = 1
    female = 1
    value.each_pair do |k, v|
      male = male * probability_density_function(v, mean_for(:male, k), variance(:male, k))
      female = female * probability_density_function(v, mean_for(:female, k), variance(:female, k))
    end
    male = male * 0.5
    female = female * 0.5
    {:male => male, :female => female}
  end

  def training_data
    @training_data ||= {}
  end

  private
  def mean_for(category, attribute)
    mean(values_for(category, attribute))
  end

  def values_for(category, attribute)
    training_data[category].map { |item| item[attribute].to_f }
  end

  def variance(category, attribute)
    sample_variance(training_data[category].map { |item| item[attribute]}, mean_for(category, attribute))
  end
end
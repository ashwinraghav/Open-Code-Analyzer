class Array
  def sum
    self.inject(& :+)
  end

  def average
    self.sum / self.size
  end
end

class BayesMeUp
  def train(hash, category)
    (training_data[category] ||= []) << hash
  end

  def gaussianify
    mean_height = calculate_mean(:male, :height)
    variance_height = calculate_variance(:male, :height)
    mean_weight = calculate_mean(:male, :weight)
    variance_weight = calculate_variance(:male, :weight)
    mean_foot = calculate_mean(:male, :foot)
    variance_foot = calculate_variance(:male, :foot)

    [mean_height, variance_height, mean_weight, variance_weight, mean_foot, variance_foot]
  end

  def nostradamus(value)
    male = 1
    female = 1
    value.each_key do |key|
      male = male * probability_density_function(value[key], mean(:male, key), calculate_variance(:male, key))
      female = female * probability_density_function(value[key], mean(:female, key), calculate_variance(:female, key))
    end
    male = male * 0.5
    female = female * 0.5
    {:male => male, :female => female}
  end

  def training_data
    @training_data ||= {}
  end

  private
  def calculate_mean(category, attribute)
    training_data[category].map { |item| item[attribute].to_f }.average
  end

  def probability_density_function(x, mean, variance)
    denom = Math.sqrt(2 * Math::PI * variance)
    power = ((x-mean)**2) / (2*variance)
    (1 / denom) * (Math::E ** (0-power))
  end

  def calculate_variance(category, attribute)
    mean = calculate_mean(category, attribute)
    numerator = training_data[category].map { |item| (item[attribute] - mean) ** 2 }.sum
    numerator / (training_data[category].size-1)
  end

  alias mean calculate_mean
  alias variance calculate_variance
end
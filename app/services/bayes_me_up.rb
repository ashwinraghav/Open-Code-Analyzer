class Array
  def sum
    self.inject(& :+)
  end

  def average
    self.sum / self.size
  end
end

class BayesMeUp
  include Statistics

  def train(hash, category)
    (training_data[category] ||= []) << hash
  end

  def gaussianify
    mean_height = mean(:male, :height)
    variance_height = variance(:male, :height)
    mean_weight = mean(:male, :weight)
    variance_weight = variance(:male, :weight)
    mean_foot = mean(:male, :foot)
    variance_foot = variance(:male, :foot)

    [mean_height, variance_height, mean_weight, variance_weight, mean_foot, variance_foot]
  end

  def nostradamus(value)
    male = 1
    female = 1
    value.each_key do |key|
      male = male * probability_density_function(value[key], mean(:male, key), variance(:male, key))
      female = female * probability_density_function(value[key], mean(:female, key), variance(:female, key))
    end
    male = male * 0.5
    female = female * 0.5
    {:male => male, :female => female}
  end

  def training_data
    @training_data ||= {}
  end

  private
  def mean(category, attribute)
    training_data[category].map { |item| item[attribute].to_f }.average
  end

  def variance(category, attribute)
    mean = mean(category, attribute)
    numerator = training_data[category].map { |item| (item[attribute] - mean) ** 2 }.sum
    numerator / (training_data[category].size-1)
  end
end
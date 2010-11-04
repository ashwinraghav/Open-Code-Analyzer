module Statistics
  def probability_density_function(x, mean, variance)
    denominator = Math.sqrt(2 * Math::PI * variance)
    power = ((x-mean)**2) / (2*variance)
    (1 / denominator) * (Math::E ** (-power))
  end

  def mean(values)
    values.inject(&:+) / values.size
  end

  # uses Bessel's correction to take into account that we're working out the variance based only
  # on a sample data set - http://en.wikipedia.org/wiki/Bessel%27s_correction
  def sample_variance(values, mean)
    values.map { |item| (item - mean) ** 2 }.inject(& :+) / (values.size - 1)
  end  
end
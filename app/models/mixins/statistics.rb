module Statistics
  def probability_density_function(x, mean, variance)
    denominator = Math.sqrt(2 * Math::PI * variance)
    power = ((x-mean)**2) / (2*variance)
    (1 / denominator) * (Math::E ** (-power))
  end
end
class Metric
  def initialize(name, mean, sample_variance)
    @name, @mean, @sample_variance = name, mean, sample_variance
  end

  def first
    @mean
  end

  def last
    @sample_variance
  end
end
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

  attr_accessor :mean, :name, :sample_variance

  def to_s
    "#{name} Mean: #{mean}, Variance #{sample_variance}"
  end
end

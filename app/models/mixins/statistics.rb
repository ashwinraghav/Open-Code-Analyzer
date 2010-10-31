module Statistics
  def self.included(base)
    base.send :extend, ClassMethods 
  end

  module ClassMethods
    def probability_density_function(x, mean, variance)
      denom = Math.sqrt(2 * Math::PI * variance)
      power = ((x-mean)**2) / (2*variance)
      (1 / denom) * (Math::E ** (0-power))
    end
  end
end
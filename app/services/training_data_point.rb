class TrainingDataPoint
  attr_accessor :fields

  def initialize(fields)
    @fields = fields
  end

  def get(name)
    @fields[name]
  end

  alias [] get
end
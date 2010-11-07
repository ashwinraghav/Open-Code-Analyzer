require 'rubygems'
require 'nokogiri'

class ProcessedMetric
  def initialize(description, value)
    @description, @value = description, value
  end

  def name
    @description.database_name
  end

  def long_name
    @description.long_name
  end

  attr_accessor :value

end

class MetricDescription
  def initialize(xml_name, long_name, database_name)
    @xml_name, @long_name, @database_name = xml_name, long_name, database_name
  end

  attr_accessor :xml_name, :long_name, :database_name 
end

class MetricsProcessor

  METRICS = [ MetricDescription.new("NOC", "Number of classes", "number_of_classes"),
              MetricDescription.new("NOM", "Number of methods", "number_of_methods"),
              MetricDescription.new("LOC", "Lines of code", "lines_of_code"),
              MetricDescription.new("CC", "Cyclomatic complexity", "total_cyclomatic_complexity"),
              MetricDescription.new("CCmax", "Maximum cyclomatic complexity", "max_cyclomatic_complexity")]

  def initialize(folder)
    @folder = folder
  end
  
  def get_metrics()
    stream = open("|lib/javancss/bin/javancss -recursive -all -xml #{@folder}").read()
    @doc = Nokogiri::XML(stream)
    METRICS.collect{ |m| ProcessedMetric.new(m, send("get_#{m.xml_name.downcase}")) }
  end
  
  def get_noc()
    xpath_value("//total/classes")
  end
  
  def get_nom()
    xpath_value("//total/functions")
  end
  
  def get_loc()
    xpath_value("//total/ncss")
  end
  
  def get_cc()
    sum = 0
    @doc.xpath("//function/ccn").each do |node|
      sum += node.inner_text.to_i
    end
    sum
  end
  
  def get_ccmax()
    max = 0
    @doc.xpath("//function/ccn").each do |node|
      val = node.inner_text.to_i
      max = val if val > max
    end
    max
  end

  def xpath_value(xpath)
    @doc.xpath(xpath).inner_text
  end
  
end

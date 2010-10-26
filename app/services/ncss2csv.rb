require 'rubygems'
require 'nokogiri'

class NcssFileProcessor

  METRICS = { "NOC" => "Number of classes",
              "NOM" =>"Number of methods",
              "LOC" =>"Lines of code",
              "CC" => "Cyclomatic complexity",
              "CCmax" => "Maximum cyclomatic complexity" }

  def initialize(file)
    @doc = Nokogiri::XML(file)
  end
  
  def get_metrics()
    METRICS.keys.collect{ |m| [METRICS[m], send("get_#{m.downcase}")] }
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
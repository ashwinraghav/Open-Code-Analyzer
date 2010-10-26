require 'services/metrics_processor'

class CodeSubmissionsController < ApplicationController
  def create  
    # here we shall add the code submission then redirect and show the metrics
  end

  def show
    folder = "public/Files-Java-9FD86"
    @metrics = MetricsProcessor.new(folder).get_metrics()
  end 
end

require 'services/ncss2csv'

class CodeSubmissionsController < ApplicationController
  def create  
    # here we shall add the code submission then redirect and show the metrics
  end

  def show
    folder = "public/Files-Java-9FD86"
    metrics_stream = open("|lib/javancss/bin/javancss -recursive -all -xml #{folder}").read()

    @metrics = NcssFileProcessor.new(metrics_stream).get_metrics()
  end 
end
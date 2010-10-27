require 'services/metrics_processor'

class CodeSubmissionsController < ApplicationController
  ZIP_FILES_ONLY = "Only files with a .zip extension are permitted"
  def create
    if params[:upload] =~ /\.zip$/
      redirect_to code_submission_path(1)
    else
      flash[:error] = ZIP_FILES_ONLY
      render :action => :new
    end
  end

  def show
    folder = "public/Files-Java-9FD86"
    @metrics = MetricsProcessor.new(folder).get_metrics()
  end 
end

require 'services/metrics_processor'

class CodeSubmissionsController < ApplicationController
  before_filter :create_code_submissions_request, :only => [:create]

  def create
    if @code_submission_request.valid?
      redirect_to code_submission_path(1)
    else
      flash.now[:error] = @code_submission_request.errors[:upload]
      render :action => :new
    end
  end

  def new
    @code_submission_request = CodeSubmissionRequest.new
  end

  def show
    folder = "public/Files-Java-9FD86"
    @metrics = MetricsProcessor.new(folder).get_metrics()
  end 

  private
  def create_code_submissions_request
    @code_submission_request = CodeSubmissionRequest.new(params[:code_submission_request])
  end
end

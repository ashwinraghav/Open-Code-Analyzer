class CodeSubmissionsController < ApplicationController
  before_filter :create_code_submissions_request, :only => [:create]
  before_filter :get_code_submissions_request, :only => :show

  def create
    if @code_submission_request.save
      redirect_to code_submission_path(@code_submission_request)
    else
      flash.now[:error] = @code_submission_request.errors[:file_name_on_client]
      render :action => :new
    end
  end

  def new
  end

  def show
    folder = @code_submission_request.extracted_folder
    @metrics = MetricsProcessor.new(folder).get_metrics()
  end

  private
  def create_code_submissions_request
    @code_submission_request = CodeSubmission.new({:file_name_on_client => params['upload']['datafile'].original_filename, :data_file => params['upload']['datafile']})
  end

  def get_code_submissions_request
    @code_submission_request = CodeSubmission.find(params[:id].to_i)
  end
end
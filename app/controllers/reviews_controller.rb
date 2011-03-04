#require 'casclient'
#require 'casclient/frameworks/rails/filter'

class CodeSubmissionsController < ApplicationController
  before_filter :create_code_submissions_request, :only => [:create]
  before_filter :get_code_submissions_request, :only => :show
  helper_method :title_text


  def create
    if @code_submission_request.save
      store_submission
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

    below_average_training_set = TrainingDataSet.new(:below_average)
    average_training_set = TrainingDataSet.new(:average)
    above_average_training_set = TrainingDataSet.new(:above_average)

    below_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 1 }
    average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 2 }
    above_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 3 }

    below_average = CodeProblems.find_by_category_and_problem("below_average", "Mars Rover")
    average = CodeProblems.find_by_category_and_problem("average", "Mars Rover")
    above_average = CodeProblems.find_by_category_and_problem("above_average", "Mars Rover")
    
    bayes = Bayes.new
    bayes.train(:below_average, below_average.metrics) 
    bayes.train(:average, average.metrics)
    bayes.train(:above_average, above_average.metrics)

    metricities = @metrics.inject({}) do |hash, processed_metric|
      hash[processed_metric.name] = processed_metric.value.to_i
      hash
    end

    @prediction = bayes.nostradamus(metricities)
    @training_sets = [below_average, average, above_average]
  end

  def judge
    rcs = ReviewedCodeSubmission.find_by_file_name(params[:id].to_s)
    rcs.pursued = params[:pursue]
    rcs.user = "Ashley"
    rcs.save!
  end

  private
  def create_code_submissions_request
    data_file = (params['upload'] || { :datafile => ''})['datafile']
    @code_submission_request = CodeSubmission.new({:file_name_on_client => data_file.respond_to?(:original_filename) ? data_file.original_filename : "", :data_file => data_file})
  end

  def get_code_submissions_request
    @code_submission_request = CodeSubmission.find(params[:id].to_i)
  end

  def title_text
    "Open Code Analyzer"
  end

  def store_submission
    folder = @code_submission_request.extracted_folder
    @metrics = MetricsProcessor.new(folder).get_metrics()

    r = ReviewedCodeSubmission.new

    @metrics.each do |m|
      r.send(m.long_name.gsub(/ /,'_').underscore + "=", m.value)
    end

    r.file_name = @code_submission_request.id.to_s
    ######################Fix This#######################################
    r.problem = "Sales Tax"
    ######################Fix This#######################################

    r.save!
  end
end

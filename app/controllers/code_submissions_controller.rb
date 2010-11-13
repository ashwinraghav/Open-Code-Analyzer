class CodeSubmissionsController < ApplicationController
  before_filter :create_code_submissions_request, :only => [:create]
  before_filter :get_code_submissions_request, :only => :show
  helper_method :title_text

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

    below_average_training_set = TrainingDataSet.new(:below_average)
    average_training_set = TrainingDataSet.new(:average)
    above_average_training_set = TrainingDataSet.new(:above_average)

    below_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 1 }
    average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 2 }
    above_average = ReviewedCodeSubmission.find_all_by_problem("Mars Rover").find_all { |r| r.rating == 3 }

    below_average.each { |r| below_average_training_set.add r if r.id % 2 == 0 }
    average.each { |r| average_training_set.add r if r.id % 2 == 0 }
    above_average.each { |r| above_average_training_set.add r if r.id % 2 == 0 }

    bayes = Bayes.new
    bayes.train(:below_average, below_average_training_set.metrics)
    bayes.train(:average, average_training_set.metrics)
    bayes.train(:above_average, above_average_training_set.metrics)

    bayes.train(:below_average, ReviewedCodeMetrics.find_by_category_and_problem(:below_average, "Mars Rover"))

    metricities = @metrics.inject({}) do |hash, processed_metric|
      hash[processed_metric.name] = processed_metric.value.to_i
      hash
    end

    @prediction = bayes.nostradamus(metricities)
    @training_sets = [below_average_training_set, average_training_set, above_average_training_set]
  end

  private
  def create_code_submissions_request
    data_file = params['upload']['datafile']
    @code_submission_request = CodeSubmission.new({:file_name_on_client => data_file.original_filename, :data_file => data_file})
  end

  def get_code_submissions_request
    @code_submission_request = CodeSubmission.find(params[:id].to_i)
  end

  def title_text
    "Open Code Analyzer"
  end
end

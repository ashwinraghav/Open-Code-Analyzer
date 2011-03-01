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

  def index
  end

  def show
    user =params[:user]? {:user => params[:user]}:{}
    @metrics = ReviewedCodeSubmission.find_by_file_name(params[:id])

    below_average = ReviewedCodeMetrics.find(:all, :conditions => {:category => "below_average", :problem => problem}.merge(user)).first
    average = ReviewedCodeMetrics.find(:all, :conditions => {:category => "average", :problem => problem}.merge(user)).first
    above_average = ReviewedCodeMetrics.find(:all, :conditions => {:category => "above_average", :problem => problem}.merge(user)).first

    bayes = Bayes.new
    bayes.train(:below_average, below_average.metrics) unless below_average.blank?
    bayes.train(:average, average.metrics)unless average.blank?
    bayes.train(:above_average, above_average.metrics)unless above_average.blank?

    @metricities = {
                    "number_of_classes" => @metrics.number_of_classes,
                    "number_of_methods" => @metrics.number_of_methods,
                    "lines_of_code" => @metrics.lines_of_code,
                    "total_cyclomatic_complexity" => @metrics.total_cyclomatic_complexity,
                    "max_cyclomatic_complexity" => @metrics.max_cyclomatic_complexity
                   }

    result = bayes.nostradamus(@metricities)
    @prediction = result.sort_by {|key, value| value}.last.first
    @training_sets = [below_average, average, above_average].compact
  end


  def judge
    h={:pass => "1", :pursue => "2", :strong_pursue => "3"}
    rcs = ReviewedCodeSubmission.find_by_file_name(params[:id].to_s)
    rcs.rating = h[params[:pursue].to_sym]
    rcs.user = "Ashley"
    rcs.save!
  end

  def reviews
    @reviewers = ReviewedCodeMetrics.find_by_sql("select distinct(user) from reviewed_code_metrics")
  end

  private

  def problem
    @code_submission_request.problem
  end

  def create_code_submissions_request
    data_file = (params['upload'] || { :datafile => ''})['datafile']
    @code_submission_request = CodeSubmission.new({:file_name_on_client => data_file.respond_to?(:original_filename) ? data_file.original_filename : "", :data_file => data_file, :problem => params['problem']})
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
    r.problem = problem
    r.save!
  end
end

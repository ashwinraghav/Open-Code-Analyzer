require 'spec_helper'

describe "Accuracy of the Bayes Algorithm" do
  it "should have some degree of accuracy" do
   load_all_data_in 

    ["Mars Rover", "Sales Tax"].each do |problem|
      below_average_training_set = TrainingDataSet.new(:below_average)
      average_training_set = TrainingDataSet.new(:average)
      above_average_training_set = TrainingDataSet.new(:above_average)

      below_average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 1}).find_all { |r| (r.id % 2) == 0 }
      average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 2}).find_all { |r| (r.id % 2) == 0 }
      above_average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 3}).find_all { |r| (r.id % 2) == 0 }

      below_average.each { |r| below_average_training_set.add r }
      average.each { |r| average_training_set.add r }
      above_average.each { |r| above_average_training_set.add r }
      training_sets = {"average" => average_training_set, "below_average" => below_average_training_set, "above_average" => above_average_training_set}

      %w{ average below_average above_average }.each do |category|
        metrics = training_sets[category].metrics
        load_data(metrics,category, problem) unless metrics.blank?
      end
    end

    below_average = CodeProblems.find(:all, :conditions => {:category => "below_average", :problem => "Mars Rover"}).first
    average = CodeProblems.find(:all, :conditions => {:category => "average", :problem => "Mars Rover"}).first
    above_average = CodeProblems.find(:all, :conditions => {:category => "above_average", :problem => "Mars Rover"}).first

    bayes = Bayes.new
    bayes.train(:below_average, below_average.metrics) unless below_average.blank?
    bayes.train(:average, average.metrics) unless average.blank?
    bayes.train(:above_average, above_average.metrics) unless above_average.blank?

    code_submissions = ReviewedCodeSubmission.all.find_all { |r| (r.id % 2) != 0 }

    h = {1 => "below_average", 2 => "average", 3 => "above_average"}
    actual_predicted = code_submissions.inject([]) do |result, code_submission|
      metricities = {
              "number_of_classes" => code_submission.number_of_classes,
              "number_of_methods" => code_submission.number_of_methods,
              "lines_of_code" => code_submission.lines_of_code,
              "total_cyclomatic_complexity" => code_submission.total_cyclomatic_complexity,
              "max_cyclomatic_complexity" => code_submission.max_cyclomatic_complexity }
      prediction = bayes.nostradamus(metricities).sort_by { |key, value| value }.last.first

      result << [prediction, h[code_submission.rating]]
      result
    end

    matches = actual_predicted.find_all { |value| value[0].to_s.eql? value[1] }
    actual_predicted.each do |ap|
      correct = ap[0].to_s.eql? ap[1]
      puts "Predicted: #{ap[0]} | Actual: #{ap[1]} #{correct}"
    end
    puts "Correct: #{matches.size} of #{code_submissions.size}"


  end

  def load_data(metrics, category, problem)
    code_problem = CodeProblems.new(:problem => problem, :category => category, :user => "mark")

    code_problem.mean_max_complexity = metrics["max_cyclomatic_complexity"].mean

    code_problem.var_max_complexity = metrics["max_cyclomatic_complexity"].sample_variance
    code_problem.mean_lines_of_code = metrics["lines_of_code"].mean
    code_problem.var_lines_of_code = metrics["lines_of_code"].sample_variance
    code_problem.mean_no_of_methods = metrics["number_of_methods"].mean

    code_problem.var_no_of_methods = metrics["number_of_methods"].sample_variance
    code_problem.mean_no_of_classes = metrics["number_of_classes"].mean
    code_problem.var_no_of_classes = metrics["number_of_classes"].sample_variance
    code_problem.mean_total_cyclomatic_complexity = metrics["total_cyclomatic_complexity"].mean
    code_problem.var_total_cyclomatic_complexity = metrics["total_cyclomatic_complexity"].sample_variance
    code_problem.save
  end

  def load_all_data_in
    mars_rover_file = CSV.read('db/cleaned_up_mars_rover_seed_data.csv')
    mars_rover_file.shift
    mars_rover_file.shift
    mars_rover_file.each do |row|
      metrics = ReviewedCodeSubmission.new({:number_of_classes            => row[1],
                                           :number_of_methods            => row[2],
                                           :lines_of_code                => row[3],
                                           :total_cyclomatic_complexity  => row[4],
                                           :max_cyclomatic_complexity    => row[5],
                                           :rating                       => row[6],
                                           :problem                      => "Mars Rover"})
      metrics.save!
    end
  end


end

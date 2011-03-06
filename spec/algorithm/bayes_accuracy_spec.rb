require 'spec_helper'

describe "Accuracy of the Bayes Algorithm" do
  it "should have some degree of accuracy" do
   load_all_data_in 
   problem = "Mars Rover"
   training_sets = create_training_sets(problem)

   %w{ average below_average above_average }.each do |category|
     metrics = training_sets[category].metrics
     load_data(metrics,category, problem) unless metrics.blank?
   end

   below_average = CodeProblems.find(:all, :conditions => {:category => "below_average", :problem => "Mars Rover"}).first
   average = CodeProblems.find(:all, :conditions => {:category => "average", :problem => "Mars Rover"}).first
   above_average = CodeProblems.find(:all, :conditions => {:category => "above_average", :problem => "Mars Rover"}).first

   bayes = create_and_train_bayes_from(below_average, average, above_average)

   code_submissions = ReviewedCodeSubmission.all.find_all { |r| (r.id % 2) == 0 }

   h = {1 => "below_average", 2 => "average", 3 => "above_average"}
   rankings = code_submissions.inject([]) do |result, code_submission|
     initial_prediction = bayes.nostradamus(code_submission.metrics)
     initial_prediction[:above_average] = initial_prediction[:above_average] * (code_submissions.find_all { |c| c.rating == 3 }.size.to_f / code_submissions.size)
     initial_prediction[:average] = initial_prediction[:average] * (code_submissions.find_all { |c| c.rating == 2 }.size.to_f / code_submissions.size)
     initial_prediction[:below_average] = initial_prediction[:below_average] * (code_submissions.find_all { |c| c.rating == 1 }.size.to_f / code_submissions.size)
     prediction = initial_prediction.sort_by { |key, value| value * -1  }.first.first

     result << [prediction, h[code_submission.rating], code_submission, initial_prediction]
     result
   end

   matches = rankings.find_all { |value| value[0].to_s.eql? value[1] }
   rankings.each do |ranking|
     correct = ranking[0].to_s.eql? ranking[1]
   end
   puts "Correct: #{matches.size} of #{code_submissions.size}"

    (rankings - matches).each do |entry|
      #puts "P: #{entry[0]} A: #{entry[1]} # classes: #{entry[2].number_of_classes} # methods: #{entry[2].number_of_methods} lines of code: #{entry[2].lines_of_code} total cc: #{entry[2].total_cyclomatic_complexity} max cc: #{entry[2].max_cyclomatic_complexity} b:#{entry[3][:below_average]} a:#{entry[3][:average]} aa: #{entry[3][:above_average]}"
    end

    bayes.training_data.each_pair do |key, value|
      puts "#{key} =>"
      value.each_pair do |k,v|
        puts "\t#{v}"
      end
    end
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
  
  def create_and_train_bayes_from(below_average, average, above_average)
    Bayes.new.tap do |bayes|
      bayes.train(:below_average, below_average.metrics) unless below_average.blank?
      bayes.train(:average, average.metrics) unless average.blank?
      bayes.train(:above_average, above_average.metrics) unless above_average.blank?
    end
  end

  def create_training_sets(problem)
    below_average_training_set = TrainingDataSet.new(:below_average)
    average_training_set = TrainingDataSet.new(:average)
    above_average_training_set = TrainingDataSet.new(:above_average)

    below_average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 1}).find_all { |r| (r.id % 2) != 0 }
    average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 2}).find_all { |r| (r.id % 2) != 0 }
    above_average = ReviewedCodeSubmission.find(:all, :conditions => {:problem => problem, :rating => 3}).find_all { |r| (r.id % 2) != 0 }

    below_average.each { |r| below_average_training_set.add r }
    average.each { |r| average_training_set.add r }
    above_average.each { |r| above_average_training_set.add r }
    {"average" => average_training_set, "below_average" => below_average_training_set, "above_average" => above_average_training_set}
  end
end

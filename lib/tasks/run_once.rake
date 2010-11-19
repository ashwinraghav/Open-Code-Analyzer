require 'csv'
namespace :run_once do
  task :load_from_files => :environment do
    mars_rover_file = CSV.read('db/cleaned_up_mars_rover_seed_data.csv')
    mars_rover_file.shift
    mars_rover_file.shift
    random_users = [
                    "Ravindra Jaju", 'Jatin Naik', "Kuldeep Ghogre",
                    "Ashwin Raghav Mohan Ganesh", "Priyank Gupta",
                    "Mark Needham", "Yekkanti Kishore", "Sushanth",
                    "Nikunj", "Jai", "Kaiser", "Avinash",
                    "Ola Bini", "Amir", "Gavri Savio Fernandez",
                    "Arvind Kunday", "Selvakumar Natesan",
                   ]
    mars_rover_file.each do |row|
      ReviewedCodeSubmission.new({:number_of_classes            => row[1],
                                  :number_of_methods            => row[2],
                                  :lines_of_code                => row[3],
                                  :total_cyclomatic_complexity  => row[4],
                                  :max_cyclomatic_complexity    => row[5],
                                  :rating                       => row[6],
                                  :problem                      => "Mars Rover",
                                  :user                         => random_users[rand(random_users.size-1)]}).save
    end

    sales_tax_file = CSV.read('db/cleaned_up_tax_seed_data.csv')
    sales_tax_file.shift
    sales_tax_file.shift

    sales_tax_file.each do |row|
      ReviewedCodeSubmission.new({:number_of_classes            => row[1],
                                  :number_of_methods            => row[2],
                                  :lines_of_code                => row[3],
                                  :total_cyclomatic_complexity  => row[4],
                                  :max_cyclomatic_complexity    => row[5],
                                  :rating                       => row[6],
                                  :problem                      => "Sales Tax",
                                  :user                         => random_users[rand(random_users.size-1)]}).save
    end
  end

  task :test => :environment do
    @correct = 0
    h = {1 => "below_average", 2 => "average", 3 => "above_average"}
    mars_rover_file = CSV.read('db/cleaned_up_mars_rover_seed_data.csv')
    mars_rover_file.shift
    mars_rover_file.shift
    mars_rover_file.each do |row|
      @metrics = ReviewedCodeSubmission.new({:number_of_classes            => row[1],
                                             :number_of_methods            => row[2],
                                             :lines_of_code                => row[3],
                                             :total_cyclomatic_complexity  => row[4],
                                             :max_cyclomatic_complexity    => row[5],
                                             :rating                       => row[6],
                                             :problem                      => "Mars Rover"})
      @metrics.save!

      below_average = ReviewedCodeMetrics.find(:all, :conditions => {:category => "below_average", :problem => "Mars Rover"}).first
      average = ReviewedCodeMetrics.find(:all, :conditions => {:category => "average", :problem => "Mars Rover"}).first
      above_average = ReviewedCodeMetrics.find(:all, :conditions => {:category => "above_average", :problem => "Mars Rover"}).first

      bayes = Bayes.new
      bayes.train(:below_average, below_average.metrics) unless below_average.blank?
      bayes.train(:average, average.metrics) unless average.blank?
      bayes.train(:above_average, above_average.metrics) unless above_average.blank?
      @metricities = {
              "number_of_classes" => @metrics.number_of_classes,
              "number_of_methods" => @metrics.number_of_methods,
              "lines_of_code" => @metrics.lines_of_code,
              "total_cyclomatic_complexity" => @metrics.total_cyclomatic_complexity,
              "max_cyclomatic_complexity" => @metrics.max_cyclomatic_complexity
      }


      result = bayes.nostradamus(@metricities)
      @prediction = result.sort_by { |key, value| value }.last.first
      if @prediction.to_s.eql? h[row[6].to_i]
        @correct = @correct + 1
      end
      
    end

    puts "correct = ", @correct
  end
end
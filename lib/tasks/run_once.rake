namespace :run_once do
  task :load_from_files => :environment do
    mars_rover_file = CSV.read('db/cleaned_up_mars_rover_seed_data.csv')
    mars_rover_file.shift
    mars_rover_file.shift

    mars_rover_file.each do |row|
      ReviewedCodeSubmission.new({:number_of_classes            => row[1],
                                  :number_of_methods            => row[2],
                                  :lines_of_code                => row[3],
                                  :total_cyclomatic_complexity  => row[4],
                                  :max_cyclomatic_complexity    => row[5],
                                  :rating                       => row[6],
                                  :problem                      => "Mars Rover"}).save
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
                                  :problem                      => "Sales Tax"}).save
    end
  end
end
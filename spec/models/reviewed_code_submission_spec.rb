require 'spec_helper'

describe ReviewedCodeSubmission do
  before(:each) do
    @valid_attributes = {}
  end

  it "should create a new instance given valid attributes" do
    ReviewedCodeSubmission.create!(@valid_attributes)
  end

  it "should return metrics" do
    code_submssion = ReviewedCodeSubmission.new({:number_of_classes            => 1,
                                                 :number_of_methods            => 2,
                                                 :lines_of_code                => 3,
                                                 :total_cyclomatic_complexity  => 4,
                                                 :max_cyclomatic_complexity    => 5,
                                                 :rating                       => 6,
                                                 :problem                      => "Mars Rover"})

    code_submssion.metrics.should == {"number_of_classes"            => 1,
                                      "number_of_methods"            => 2,
                                      "lines_of_code"                => 3,
                                      "total_cyclomatic_complexity"  => 4,
                                      "max_cyclomatic_complexity"    => 5}
  end
end

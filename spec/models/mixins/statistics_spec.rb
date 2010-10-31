require 'spec_helper'

describe Statistics do

  class Sample
    include Statistics
  end

    # Based on wikipedia examples - http://en.wikipedia.org/wiki/Naive_Bayes_classifier

    it "pdf for weight" do
      Sample.new.probability_density_function(130, 176.25, 1.2292e+02).should be_close(5.9881e-06, 0.0000000001)
    end

    it "pdf for height" do
      Sample.new.probability_density_function(6, 5.855, 3.5033e-02).should be_close(1.5789, 0.0001)
    end

    it "mean" do
      Sample.new.mean([1,2,3]).should == 2
    end
end
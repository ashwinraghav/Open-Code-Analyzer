require 'spec_helper'

describe BayesMeUp do
  it "with wiki example" do
    bayes = BayesMeUp.new

    males = [{:height => 6, :weight => 180, :foot => 12}, {:height => 5.92, :weight => 190, :foot => 11}, {:height => 5.58, :weight => 170, :foot => 12}, {:height => 5.92, :weight => 165, :foot => 10}]
    males.each do |male|
      bayes.train(male, :male)
    end

    females = [{:height => 5, :weight => 100, :foot => 6}, {:height => 5.5, :weight => 150, :foot => 8}, {:height => 5.42, :weight => 130, :foot => 7}, {:height => 5.75, :weight => 150, :foot => 9}]
    females.each do |female|
      bayes.train(female, :female)
    end

    prediction = bayes.nostradamus({:height => 6, :weight =>130, :foot => 8})
    prediction[:male].should be_close(6.19707184387809e-09, 0.0000000001)
    prediction[:female].should be_close(0.000537790918363002, 0.000000001)
  end
end
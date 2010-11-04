class ReviewedCodeSubmission < ActiveRecord::Base
  def metrics
   self.attributes.reject { |attr_name,_| attr_name == "id" or attr_name == "rating" }
  end

  def has_code?
    lines_of_code > 0
  end
end
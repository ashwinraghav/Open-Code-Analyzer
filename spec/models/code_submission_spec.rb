require 'spec_helper'

describe CodeSubmission do
  it "should be invalid on an upload with a non .zip extension" do
    params = {:file_name_on_client => "this_is_not_a_zip_file.tar", :data_file => ""}
    request = CodeSubmission.new(params)
    request.save.should be_false
    request.errors.on(:file_name_on_client).should == CodeSubmission::ZIP_FILES_ONLY
  end

  it "should be valid an upload with .zip extension" do
    params = {:file_name_on_client => "this_is_a_zip_file.zip", :data_file => mock("data_file", :read => "")}
    request = CodeSubmission.new(params)
    request.save.should be_true
    request.errors.on(:file_name_on_client).should == nil
  end

end

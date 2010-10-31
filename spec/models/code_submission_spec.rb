require 'spec_helper'

describe CodeSubmission do
  it "should be invalid on an upload with a non .zip extension" do
    request = CodeSubmission.new({:upload => "non/zip.extension"})
    request.save({}).should be_false
    request.errors.on(:upload).should == CodeSubmission::ZIP_FILES_ONLY
  end
  
  it "should be valid an upload with .zip extension" do
    request = CodeSubmission.new({:upload => "non/something.zip"})

    uploaded_file = double("uploaded_file")
    uploaded_file.stub!(:original_filename).and_return("non/something.zip")
    uploaded_file.stub!(:read)
    uploaded_file_params = {"datafile" => uploaded_file}

    File.stub!("open")

    request.save(uploaded_file_params).should be_true
    request.errors.on(:upload).should == nil 
  end

end

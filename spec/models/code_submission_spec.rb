require 'spec/spec_helper'

describe CodeSubmission do
  it "should be invalid on an upload with a non .zip extension" do
    request = CodeSubmission.new({:upload => "non/zip.extension"})
    request.save.should be_false
    request.errors.on(:upload).should == CodeSubmission::ZIP_FILES_ONLY
  end
  
  it "should be valid an upload with .zip extension" do
    request = CodeSubmission.new({:upload => "non/something.zip"})
    request.save.should be_true
    request.errors.on(:upload).should == nil 
  end

end

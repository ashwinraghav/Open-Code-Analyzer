require 'spec/spec_helper'

describe CodeSubmission do
  it "should reject an upload with a non .zip extension" do
    request = CodeSubmission.new({:upload => "non/zip.extension"})
    request.valid?.should be_false
    request.errors.on(:upload).should == CodeSubmission::ZIP_FILES_ONLY
  end
  
  it "should be valid an upload with .zip extension" do
    request = CodeSubmission.new({:upload => "non/something.zip"})
    request.valid?.should be_true
    request.errors.on(:upload).should == nil 
  end


  it "should not reject an upload which does have a zip extension" do 
    request = CodeSubmission.new({:upload => "/Users/mneedham/Downloads/4beauty-export.zip"})
    request.save.should be_true
  end




end

require 'spec/spec_helper'

describe CodeSubmissionRequest do
  it "should reject an upload with a non .zip extension" do
    request = CodeSubmissionRequest.new({:upload => "non/zip.extension"})
    request.valid?.should be_false
    request.errors.on(:upload).should == CodeSubmissionRequest::ZIP_FILES_ONLY
  end

  it "should not reject an upload which does have a zip extension" do 
    request = CodeSubmissionRequest.new({:upload => "/Users/mneedham/Downloads/4beauty-export.zip"})
    request.valid?.should be_true
  end
end

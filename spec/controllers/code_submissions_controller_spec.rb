require 'spec/spec_helper'

describe CodeSubmissionsController do
  describe "zip extension file" do
    it "will be uploaded" do
      get :create, :code_submission_request => { :upload => "some_file.zip" } 
      response.should redirect_to code_submission_path(1)
    end
  end
  describe "non zip extension file" do
    it "returns error message" do
      get :create, :code_submission_request => { :upload => "c:/some/shit" }
      response.flash[:error].should == CodeSubmissionRequest::ZIP_FILES_ONLY 
      response.should render_template "new"
    end

    it "keeps the name of the selected file in the field" do 
      get :create, :code_submission_request => { :upload => "c:/some/shit" }

      assigns(:code_submission_request).upload.should == "c:/some/shit"
    end
  end
end

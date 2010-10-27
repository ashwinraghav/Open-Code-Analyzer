require 'spec/spec_helper'

describe CodeSubmissionsController do
  describe "zip extension file" do
    it "will be uploaded" do
      get :create, :upload => "some_file.zip" 
      response.should redirect_to code_submission_path(1)
    end

  describe "non zip extension file" do
    it "returns error message" do
      get :create, :upload => "c:/some/shit"
      response.flash[:error].should == CodeSubmissionsController::ZIP_FILES_ONLY 
      response.should render_template "new"
    end

    it "keeps the name of the selected file in the field" do 
      get :create, :upoad => "c:/some/shit"

      assigns(:code_submission).file_name.should == "c:/some/shit"
    end
  end
end

require 'spec_helper'

describe CodeSubmissionsController do
  describe "zip extension file" do
    it "will be uploaded" do
      uploaded_file = double("uploaded_file")
      uploaded_file.stub!(:original_filename).and_return("some_file.zip")
      uploaded_file.stub!(:read)

      File.stub!("open")

      get :create, :upload => {"datafile" => uploaded_file}

      response.should redirect_to code_submission_path(1)
    end
  end
  describe "non zip extension file" do
    it "returns error message" do
      uploaded_file = double("uploaded_file")
      uploaded_file.stub!(:original_filename).and_return("c:/some/shit.extension")
      uploaded_file.stub!(:read)

      get :create, :upload => {"datafile" => uploaded_file}

      response.flash[:error].should == CodeSubmissionRequest::ZIP_FILES_ONLY
      response.should render_template "new"
    end

    it "keeps the name of the selected file in the field" do
      uploaded_file = double("uploaded_file")
      uploaded_file.stub!(:original_filename).and_return("c:/some/shit.extension")
      uploaded_file.stub!(:read)

      get :create, :upload => {"datafile" => uploaded_file}

      assigns(:code_submission_request).upload.should == "c:/some/shit.extension"
    end
  end
end

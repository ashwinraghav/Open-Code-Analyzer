require 'spec_helper'

describe CodeSubmissionsController do

  describe "zip extension file" do

    before :each do
      CodeSubmission.any_instance.expects(:unzip_file).returns(true)
    end

    it "will be uploaded" do
      uploaded_file = mock(:uploaded_file, :original_filename => "some_file.zip", :read => "")

      File.stub!("open")

      get :create, :upload => {"datafile" => uploaded_file}

      response.should redirect_to code_submission_path(1)
    end
  end

  describe "non zip extension file" do
    it "returns error message" do
      uploaded_file = mock(:uploaded_file, :original_filename => "c:/some/some_file.extension", :read => "")
  
      get :create, :upload => {"datafile" => uploaded_file}

      response.flash[:error].should == CodeSubmissionRequest::ZIP_FILES_ONLY
      response.should render_template "new"
    end
  end

  describe "show action" do

  end

end

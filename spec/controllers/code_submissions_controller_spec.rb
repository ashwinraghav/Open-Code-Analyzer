require 'spec_helper'

describe CodeSubmissionsController do

  describe "zip extension file" do

    before :each do
      CodeSubmission.any_instance.expects(:unzip_file).returns(true)
    end

    it "will be uploaded" do
      uploaded_file = mock(:uploaded_file, :original_filename => "some_file.zip", :read => "")

      File.stub!("open")

      put :create, :upload => {"datafile" => uploaded_file}

      response.should redirect_to code_submission_path(1)
    end
  end

  describe "non zip extension file" do
    it "returns error message" do
      uploaded_file = mock(:uploaded_file, :original_filename => "c:/some/some_file.extension", :read => "")
  
      put :create, :upload => {"datafile" => uploaded_file}

      response.flash[:error].should == CodeSubmissionRequest::ZIP_FILES_ONLY
      response.should render_template "new"
    end
  end
  describe "show action" do
    it "should get the metrics with the newly unzipped folder" do
      folder_path = "this/is/a/folder/path/"
      code_submission_mock = mock(:code_submission, :extracted_folder => folder_path)

      metrics_mock = mock(:metrics, :get_metrics => "muhahahaha")

      CodeSubmission.should_receive(:find).with(22).and_return(code_submission_mock)
      MetricsProcessor.should_receive(:new).with(folder_path).and_return(metrics_mock)
      File.stub!("open")

      get :show, :id => 22

      assigns[:metrics].should == "muhahahaha"

    end
  end

end
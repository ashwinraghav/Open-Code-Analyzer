require 'spec_helper'

describe CodeSubmission do

  describe "validity" do

    before :each do
      CodeSubmission.any_instance.expects(:unzip_file).returns(true)
    end

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

  describe "unzipping file" do

    it "should create a folder with the same name as the id", :pending => true do
      #file_name_on_server = File.join(CodeSubmission::DIRECTORY, id.to_s + ".zip")

      #params = {:file_name_on_client => "this_is_a_zip_file.zip", :id => 323, :data_file => mock("data_file", :read => "")}
      #request = CodeSubmission.new(params)
      #request.save

      #zip_file = mock(:zip_file)
      #zip_file.should_receive(:each).and_yield(file)
      #zip_file.should_receive(:extract)
      #file = mock(:file)
      #file.shoule_receive(:name).and_return("some_file")


      #Zip::ZipFile.should_receive(:open).with(file_name_on_server).and_yield(zip_file)
      #FileUtils.should_receive(:mkdir_p).with()
    end

  end

end

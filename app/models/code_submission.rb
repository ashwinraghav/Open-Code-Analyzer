class CodeSubmission < ActiveRecord::Base
  ZIP_FILES_ONLY = "Only files with a .zip extension are permitted"
  attr_accessor :upload
  validates_format_of :upload, :with => /\.zip$/, :message => ZIP_FILES_ONLY

  def save (uploaded_file_params)
    @upload_params = uploaded_file_params
    super
  end

  def after_save
    me =  @upload_params['datafile'].original_filename
    directory = "public/data"
    path = File.join(directory, id.to_s + ".zip")
    File.open(path, "wb") { |f| f.write(@upload_params['datafile'].read) }
  end
end

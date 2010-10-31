class CodeSubmission < ActiveRecord::Base
  ZIP_FILES_ONLY = "Only files with a .zip extension are permitted"
  DIRECTORY = "public/data"


  attr_accessor :file_name_on_client, :data_file

  validates_format_of :file_name_on_client, :with => /\.zip$/, :message => ZIP_FILES_ONLY

  def after_save
    path = File.join(DIRECTORY, id.to_s + ".zip")
    File.open(path, "wb") { |f| f.write(@data_file.read) }
  end

end
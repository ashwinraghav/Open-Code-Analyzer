require 'zip/zip'

class CodeSubmission < ActiveRecord::Base
  ZIP_FILES_ONLY = "Only files with a .zip extension are permitted"
  DIRECTORY = "public/data/"
  attr_accessor :file_name_on_client, :data_file, :file_name_on_server

  validates_format_of :file_name_on_client, :with => /\.zip$/, :message => ZIP_FILES_ONLY

  def after_save
    @file_name_on_server = File.join(DIRECTORY, id.to_s + ".zip")
    File.open(@file_name_on_server, "wb") { |f| f.write(@data_file.read) }
    unzip_file
  end

  def unzip_file
    Zip::ZipFile.open(@file_name_on_server) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(extracted_folder, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end
  end

  def extracted_folder
    DIRECTORY + id.to_s
  end
end

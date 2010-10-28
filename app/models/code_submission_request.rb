class CodeSubmissionRequest < ActiveRecord::Base
  ZIP_FILES_ONLY = "Only files with a .zip extension are permitted"

  validates_format_of :upload, :with => /\.zip$/, :message => ZIP_FILES_ONLY
  
  def self.columns() @columns ||= []; end      
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,  sql_type.to_s, null)
  end

  column :upload, :string

end

class AddFilenameReviewedCodeSubmissions < ActiveRecord::Migration
    def self.up
      add_column :reviewed_code_submissions, :file_name, :string
    end

    def self.down
      remove_column :reviewed_code_submissions, :file_name
    end
end

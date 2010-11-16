# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101116182413) do

  create_table "code_submissions", :force => true do |t|
    t.integer "reviewed_code_submission_id"
  end

  create_table "reviewed_code_metrics", :force => true do |t|
    t.string "problem"
    t.string "category"
    t.float  "mean_max_complexity"
    t.float  "var_max_complexity"
    t.float  "mean_no_of_methods"
    t.float  "var_no_of_methods"
    t.float  "mean_total_cyclomatic_complexity"
    t.float  "var_total_cyclomatic_complexity"
    t.float  "mean_no_of_classes"
    t.float  "var_no_of_classes"
    t.float  "mean_lines_of_code"
    t.float  "var_lines_of_code"
  end

  create_table "reviewed_code_submissions", :force => true do |t|
    t.integer "number_of_classes"
    t.integer "number_of_methods"
    t.integer "lines_of_code"
    t.integer "total_cyclomatic_complexity"
    t.integer "max_cyclomatic_complexity"
    t.integer "rating"
    t.string  "problem"
    t.boolean "pursued"
    t.string  "file_name"
    t.string  "user"
  end

end

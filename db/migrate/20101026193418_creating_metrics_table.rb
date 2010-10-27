class CreatingMetricsTable < ActiveRecord::Migration
  def self.up
    create_table :metrics do |t|
      t.string :email_address
      t.boolean :pursue
    end
  end

  def self.down
    drop_table :metrics
  end
end

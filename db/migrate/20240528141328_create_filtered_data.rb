class CreateFilteredData < ActiveRecord::Migration[7.1]
  def change
    create_table :filtered_data do |t|
      t.json :data

      t.timestamps
    end
  end
end

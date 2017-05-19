class CreateDispensers < ActiveRecord::Migration[5.0]
  def change
    create_table :dispensers do |t|
      t.integer :'100'
      t.integer :'50'
      t.integer :'20'
      t.integer :'10'
      t.integer :'5'
      t.integer :'1'

      t.timestamps
    end
  end
end

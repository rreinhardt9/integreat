class CreateIntegreatApps < ActiveRecord::Migration[6.0]
  def change
    create_table :integreat_apps do |t|
      t.string :name
      t.text :description
      t.string :webhook_url
      t.string :webhook_secret
      t.string :secret
      t.text :webhook_events, array:true, default: []
      t.text :api_scopes, array:true, default: []
      t.string :entry_url
      t.integer :state, default: 0
      t.integer :availability, default: 0

      t.timestamps
    end
    add_index :integreat_apps, :secret, unique: true
  end
end

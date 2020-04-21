class CreateIntegreatInstallations < ActiveRecord::Migration[6.0]
  def change
    create_table :integreat_installations do |t|
      t.integer :account_id
      t.string :account_type
      t.integer :app_id
      t.string :secret
      t.text :authorized_webhook_events, array:true, default: []
      t.text :authorized_api_scopes, array:true, default: []

      t.timestamps
    end
    add_index :integreat_installations, :secret, unique: true
  end
end

class DeviseTokenAuthCreatePlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :tokens, :json
    add_column :players, :provider, :string, null: false, default: :email
    add_column :players, :uid, :string, null: false, default: ''
    add_column :players, :email, :string
  end
end
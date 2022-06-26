class CreateExchangeRates < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates do |t|
      t.decimal :rate
      t.date :registered_at_source_for

      t.timestamps
    end
  end
end

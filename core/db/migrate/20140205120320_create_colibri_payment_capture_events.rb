class CreateColibriPaymentCaptureEvents < ActiveRecord::Migration
  def change
    create_table :colibri_payment_capture_events do |t|
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.integer :payment_id

      t.timestamps
    end

    add_index :colibri_payment_capture_events, :payment_id
  end
end

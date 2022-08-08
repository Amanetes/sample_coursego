# frozen_string_literal: true

# Migration responsible for creating a table with activity
# Баг c PG и PublicActivity - название таблицы переименовать во множественное число
class CreateActivities < ActiveRecord::Migration[5.0]
  def self.up
    create_table :activity do |t|
      t.belongs_to :trackable, polymorphic: true
      t.belongs_to :owner, polymorphic: true
      t.string :key
      t.text :parameters
      t.belongs_to :recipient, polymorphic: true

      t.timestamps
    end

    add_index :activity, %i[trackable_id trackable_type]
    add_index :activity, %i[owner_id owner_type]
    add_index :activity, %i[recipient_id recipient_type]
  end

  # Drop table
  def self.down
    drop_table :activity
  end
end

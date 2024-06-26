class CreatePostThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :post_threads do |t|
      t.integer   :user_id,       null: false
      t.integer   :group_id,      null: false
      t.string    :title,         null: false
      t.text      :body,          null: false
      
      t.timestamps
    end
  end
end

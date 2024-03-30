class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    # specifies how the articles table should be constructed 
    create_table :articles do |t|
      # added by the generator because we included them in our generate command
      # $ bin/rails generate model Article title:string body:text
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end

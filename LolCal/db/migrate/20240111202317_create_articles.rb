class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    # specifies how the articles table should be constructed 
    create_table :users do |t|
      # added by the generator because we included them in our generate command
      # $ bin/rails generate model Article title:string body:text
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end

class Build < ApplicationRecord
    belongs_to :user, foreign_key: "user_id", optional: true
    has_many :build_items, foreign_key: 'build_id', dependent: :destroy
    
    def display_name
        "#{name}"
    end

    def display_user
        "#{User.find(user_id).last_name}, #{User.find(user_id).first_name}"
    end
end

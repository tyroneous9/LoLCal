class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :course_schedules, foreign_key: 'users_id'
    # has_many :course_schedules
    validates :first_name, presence: true
    validates :last_name, presence: true
    def display_name
        "#{last_name}, #{first_name}"
    end
end

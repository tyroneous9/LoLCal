class CourseSchedule < ApplicationRecord
  belongs_to :user, foreign_key: 'users_id', optional: true
  has_many :enrolled_courses, foreign_key: 'course_schedules_id', dependent: :destroy
  # belongs_to :user, optional: true
  def display_name
    "#{quarter_name}"
  end

  def display_user
    "#{User.find(users_id).last_name}, #{User.find(users_id).first_name}"
  end 
end

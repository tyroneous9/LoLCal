class EnrolledCourse < ApplicationRecord
  belongs_to :course_schedule, foreign_key: 'course_schedules_id', optional: true
  # belongs_to :courseschedule, optional: true
end

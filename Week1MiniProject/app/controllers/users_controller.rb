class UsersController < ApplicationController
  def index
    @course_schedules = CourseSchedule.all
    @course_schedules = CourseSchedule.includes(:enrolled_courses).all
  end
end

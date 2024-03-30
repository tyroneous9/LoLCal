class EnrolledCoursesController < ApplicationController

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @enrolled_courses = user.course_schedules.flat_map(&:enrolled_courses)
    else
      @enrolled_courses = EnrolledCourse.all
    end
  end

  def new
    @enrolled_course = EnrolledCourse.new
    @course_schedules = CourseSchedule.all
  end

  def create
    @enrolled_course = EnrolledCourse.new(enrolled_course_params)
    if @enrolled_course.save
      redirect_to enrolled_courses_path, notice: 'Enrolled course was successfully created.'
    else
      render :new
    end
  end

  def show
    @enrolled_course = EnrolledCourse.find(params[:id])
  end

  def edit
    @enrolled_course = EnrolledCourse.find(params[:id])
    @course_schedules = CourseSchedule.all
  end

  def update
    @enrolled_course = EnrolledCourse.find(params[:id])
    if @enrolled_course.update(enrolled_course_params)
      redirect_to enrolled_course_path(@enrolled_course), notice: 'course was updated.'
    else
      render :edit
    end
  end

  def destroy
    @enrolled_course = EnrolledCourse.find(params[:id])
    @enrolled_course.destroy
    redirect_to enrolled_courses_path, notice: 'course was destroyed.'
  end

  private

  def enrolled_course_params
    params.require(:enrolled_course).permit(:course_name, :course_schedules_id, :course_day_of_week, :course_meeting_start, :course_meeting_end)
  end
end

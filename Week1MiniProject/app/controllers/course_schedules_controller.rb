class CourseSchedulesController < ApplicationController
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @course_schedules = user.users.flat_map(&:course_schedules)
    else
      @course_schedules = CourseSchedule.all
    end
  end

  def new
    @course_schedule = CourseSchedule.new
    @users = User.all
  end

  def create
    @course_schedule = CourseSchedule.new(course_schedule_params)
    if @course_schedule.save
      redirect_to course_schedules_path, notice: 'Course Schedule was successfully created.'
    else
      render :new
    end
  end

  def show
    @course_schedule = CourseSchedule.find(params[:id])
  end

  def edit
    @course_schedule = CourseSchedule.find(params[:id])
    @users = User.all
  end

  def update
    @course_schedule = CourseSchedule.find(params[:id])
    if @course_schedule.update(course_schedule_params)
      redirect_to course_schedule_path(@course_schedule), notice: 'course schedule was updated.'
    else
      render :edit
    end
  end

  def destroy
    @course_schedule = CourseSchedule.find(params[:id])
    @course_schedule.destroy
    redirect_to @course_schedule, notice: 'course schedule was destroyed.'
  end


  private

  def course_schedule_params
    params.require(:course_schedule).permit(:users_id, :quarter_name)
  end
end

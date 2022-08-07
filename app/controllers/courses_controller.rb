# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy]

  def index
    # if params[:title]
    #   @courses = Course.where('title ILIKE ?', "%#{params[:title]}%") # case-insensitive
    # else
    #   # Course.all
    #   @q = Course.ransack(params[:q])
    #   @courses = @q.result.includes(:user)
    # end
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
    @courses = @ransack_courses.result.includes(:user)
  end

  def show
  end

  def new
    @course = current_user.courses.build
    authorize_course!
  end

  def edit
    authorize_course!
  end

  def create
    @course = current_user.courses.build(course_params)
    authorize_course!
    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize_course!
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:id])
  end

  def authorize_course!
    authorize(@course || Course)
  end

  def course_params
    params.require(:course).permit(:title, :description, :short_description, :price, :language, :level)
  end
end

# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[show edit update destroy]
  def index
    @lessons = Lesson.all
  end

  def show
    authorize_lesson!
  end

  def new
    @lesson = Lesson.new
    @course = Course.friendly.find(params[:course_id])
  end

  def edit
    authorize_lesson!
  end

  def create
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course.lessons.build(lesson_params)

    # @course = Course.friendly.find(params[:course_id])
    # @lesson.course_id = @course.id

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to course_lesson_url(@course, @lesson), notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize_lesson!
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to course_lesson_url(@course, @lesson), notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize_lesson!
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_lesson
    @lesson = Lesson.friendly.find(params[:id])
    @course = Course.friendly.find(params[:course_id])
  end

  def authorize_lesson!
    authorize(@lesson || Lesson)
  end

  def lesson_params
    params.require(:lesson).permit(:title, :content, :course_id)
  end
end

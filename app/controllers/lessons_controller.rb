# frozen_string_literal: true

class LessonsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_lesson, only: %i[show edit update destroy delete_video]
  before_action :set_course, except: %i[index]

  # Удалить видео и превью в форме
  def delete_video
    authorize @lesson, :edit?
    @lesson.video.purge
    @lesson.video_thumbnail.purge
    redirect_to edit_course_lesson_path(@course, @lesson), notice: 'Video successfully deleted!'
  end

  # Not implemented. Для работы вместе с jquery
  # Для drag-n-drop уроков в списке
  # def sort
  #   @course = Course.friendly.find(params[:course_id])
  #   lesson = Lesson.friendly.find(params[:lesson_id])
  #   authorize lesson, :edit?
  #   lesson.update(lesson_params)
  #   render body: nil
  # end

  def index
    @lessons = Lesson.all
  end

  def show
    authorize_lesson!
    current_user.view_lesson(@lesson)
    @lessons = @course.lessons.rank(:row_order)
    @comment = Comment.new
    @comments = @lesson.comments.order(created_at: :desc)
  end

  def new
    @lesson = Lesson.new
  end

  def edit
    authorize_lesson!
  end

  def create
    @lesson = @course.lessons.build(lesson_params)

    # @course = Course.friendly.find(params[:course_id])
    # @lesson.course_id = @course.id
    authorize_lesson!
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
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def authorize_lesson!
    authorize(@lesson || Lesson)
  end

  # Убрать course_id из permitted params по соображениям безопасности.
  # Id все равно присваивается в экшене create через ассоциации
  # Row_order_position для сортировки
  def lesson_params
    params.require(:lesson).permit(:title, :content, :row_order_position, :video, :video_thumbnail)
  end
end

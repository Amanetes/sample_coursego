# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_lesson, only: :create
  before_action :set_course, only: :create

  def create
    @comment = @lesson.comments.build(comment_params)
    # @comment.lesson_id = @lesson.id
    @comment.user = current_user


    # if @comment.save
    #  redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully created.'
    # else
    #  redirect_to course_lesson_path(@course, @lesson), alert: 'Something missing.'
    # end

    respond_to do |format|
      if @comment.save
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render 'lessons/comments/new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def set_lesson
    @lesson = Lesson.friendly.find(params[:lesson_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

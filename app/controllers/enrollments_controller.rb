# frozen_string_literal: true

class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[show edit update destroy]
  before_action :set_course, only: %i[new create]

  def index
    @pagy, @enrollments = pagy(Enrollment.all)
    authorize_enrollment!
  end

  def show
  end

  def new
    authorize_enrollment!
    @enrollment = Enrollment.new
  end

  def edit
    authorize_enrollment!
  end

  def create
    if @course.price.positive?
      flash[:alert] = 'You cannot access paid courses yet.'
      redirect_to new_course_enrollment_path(@course)
    else
      @enrollment = current_user.buy_course(@course)
      redirect_to course_path(@course), notice: 'You are enrolled!'
    end
  end

  def update
    authorize_enrollment!
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize_enrollment!
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def authorize_enrollment!
    authorize(@enrollment || Enrollment)
  end

  def enrollment_params
    params.require(:enrollment).permit(:rating, :review)
  end
end

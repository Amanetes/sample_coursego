# frozen_string_literal: true

class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_course, only: %i[show edit update destroy approve unapprove]
  after_action :verify_authorized, except: %i[purchased created pending_review index]
  def index
    # if params[:title]
    #   @courses = Course.where('title ILIKE ?', "%#{params[:title]}%") # case-insensitive
    # else
    #   # Course.all
    #   @q = Course.ransack(params[:q])
    #   @courses = @q.result.includes(:user)
    # end
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    # @courses = @ransack_courses.result.includes(:user) not needed if we use pagy

    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
  end

  def purchased
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def created
    @ransack_path = created_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  # Для админки, чтобы админ, знал какие курсы еще не утверждены
  def unapproved
    authorize Course, :unapproved?
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def approve
    authorize @course, :approve? # Query = Полиси
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: "Course approved and visible!"
  end

  def unapprove
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, notice: "Course upapproved and hidden!"
  end

  def show
    authorize_course!
    @lessons = @course.lessons
    @enrollments_with_review = @course.enrollments.reviewed
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
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to @course, alert: 'Course has enrollments. Can not be destroyed.'
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
    params.require(:course).permit(:title, :description, :short_description, :price, :published, :language, :level)
  end
end

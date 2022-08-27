# frozen_string_literal: true

class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # Просматривать контент курса может админ, создатель курсы или купивший курс
  def show?
    @user.has_role?(:admin) || @record.course.user_id == @user.id || !@record.course.bought?(@user)
  end

  def edit?
    @user.present? && @record.course.user_id == @user.id
  end

  def update?
    @record.course.user_id == @user.id
  end

  def new?
    @record.course.user_id == @user.id
  end

  def create?
    @record.course.user_id == @user.id
  end

  def destroy?
    @record.course.user_id == @user.id
  end
end

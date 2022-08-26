# frozen_string_literal: true

class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def edit?
    @record.user == @user
  end

  def update?
    @record.user == @user
  end

  def new?
    @user.has_role?(:teacher)
  end

  def approve?
    @user.has_role?(:admin)
  end

  def unapproved?
    @user.has_role?(:admin)
  end

  def create?
    @user.has_role?(:teacher)
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user
  end

  def owner?
    @record.user == @user
  end
end

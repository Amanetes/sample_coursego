# frozen_string_literal: true

class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # Если курс опубликован и утвержден - любой может просматривать
  # Если админ - может просматривать люобой курс, даже неопубликованный
  # Если создатель курса - может просматривать
  # Если курс куплен - может просматривать
  def show?
    ready? ||
      @user&.has_role?(:admin) ||
      (@user.present? && @record.user == @user) ||
      (@user.present? && @record.bought?(@user))
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
    @record.user == @user && @record.enrollments.none?
    # @user.has_role?(:admin) || @record.user == @user
  end

  def owner?
    @record.user == @user
  end

  def admin_or_owner?
    @user.has_role?(:admin) || @record.user == @user
  end

  private

  def ready?
    @record.published && @record.approved
  end
end

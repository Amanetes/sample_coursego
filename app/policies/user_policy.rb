# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # Просматривать список всех пользователей может только админ
  def index?
    @user.has_role?(:admin)
  end

  def edit?
    @user.has_role?(:admin)
  end

  def update?
    @user.has_role?(:admin)
  end
end

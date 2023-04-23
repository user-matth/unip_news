class ArticlePolicy < ApplicationPolicy

  def create?
    user&.id
  end

  def show?
    true
  end

  def update?
    user&.id == record.user.id
  end

  def destroy?
    user&.id == record.user.id
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

end

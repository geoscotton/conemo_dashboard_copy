# Dictates authorization rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin? || user.nurse?
      can :manage, :all
    end
  end
end

# Dictates authorization rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      authorize_admin user
    elsif user.nurse?
      authorize_nurse user
    end

    can :manage, ActiveRecord::Relation do |relation|
      relation.all? { |model| can?(:manage, model) }
    end
  end

  private

  def authorize_admin(admin)
    can :manage, Lesson, locale: admin.locale
    can :manage, BitCore::Slide
    can :manage, Participant, locale: admin.locale
    can :manage, User, locale: admin.locale
  end

  def authorize_nurse(nurse)
    can :manage, Participant, locale: nurse.locale
  end
end

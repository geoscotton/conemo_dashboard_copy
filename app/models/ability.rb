# frozen_string_literal: true
# Dictates authorization rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_a? Superuser
      can :manage, :all

      return
    end

    if user.admin?
      authorize_admin user
    elsif user.is_a? NurseSupervisor
      authorize_nurse_supervisor user
    elsif user.nurse?
      authorize_nurse user
    end

    [:read, :create, :update, :destroy, :manage].each do |permission|
      can permission, ActiveRecord::Relation do |relation|
        relation.all? { |model| can?(permission, model) }
      end
    end
  end

  private

  def authorize_admin(admin)
    can :manage, BitCore::Slide
    can :manage, Device, participant: { locale: admin.locale }
    can :manage, Lesson, locale: admin.locale
    can :manage, Participant, locale: admin.locale
    can :read, PastDeviceAssignment, participant: { locale: admin.locale }
    can :manage, User, locale: admin.locale
    # Rails Admin specific abilities
    can :access, :rails_admin
    can :dashboard
  end

  def authorize_nurse_supervisor(supervisor)
    can [:read, :update], Participant, locale: supervisor.locale
    can :read,
        NurseTask,
        participant: { locale: supervisor.locale }
    can [:create, :update],
        SupervisorNote,
        nurse: { nurse_supervisor_id: supervisor.id }
    can :update,
        SupervisorNotification,
        nurse_task: { nurse: { nurse_supervisor_id: supervisor.id } }
    can [:read, :create],
        SupervisionSession,
        nurse: { nurse_supervisor_id: supervisor.id }
  end

  def authorize_nurse(nurse)
    can [:read, :update],
        Participant,
        nurse_id: nurse.id, status: Participant::ACTIVE
    can :create,
        AdditionalContact,
        participant: { nurse_id: nurse.id, status: Participant::ACTIVE }
    can [:create, :update],
        [
          CallToScheduleFinalAppointment, FinalAppointment, FirstAppointment,
          FirstContact, PatientContact, SecondContact, ThirdContact
        ],
        participant: { nurse_id: nurse.id, status: Participant::ACTIVE }
    can :create,
        [HelpRequestCall, LackOfConnectivityCall, NonAdherenceCall],
        participant: { nurse_id: nurse.id, status: Participant::ACTIVE }
    can [:read, :update],
        NurseTask,
        participant: { nurse_id: nurse.id, status: Participant::ACTIVE }
    can :create,
        [ScheduledTaskCancellation, ScheduledTaskRescheduling],
        nurse_task: {
          participant: { nurse_id: nurse.id, status: Participant::ACTIVE }
        }
  end
end

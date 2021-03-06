RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authorize_with do
  #   redirect_to main_app.root_path unless warden.user.admin?
  # end
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    export
    new do
      only [Admin, Nurse, NurseSupervisor, NurseTask]
    end
    edit do
      only [Admin, Nurse, NurseSupervisor, NurseTask, Participant]
    end
    bulk_delete
    show
    delete
    show_in_app
  end

  config.model Admin do
    object_label_method do
      :last_and_first_name
    end

    edit do
      field :email
      field :phone
      field :first_name
      field :last_name
      field :locale, :enum do
        enum { %w( en pt-BR es-PE ) }
      end
      field :timezone, :hidden do
        default_value do
          bindings[:view].current_user.timezone
        end
      end
      field :role, :hidden do
        default_value do
          "admin"
        end
      end
    end
  end

  config.model ContentAccessEvent do
    navigation_label "Transmitted"
  end

  config.model Device do
    navigation_label "Transmitted"

    list do
      field :model
      field :device_version
      field :participant
      field :last_seen_at
    end
  end

  config.model FinalAppointment do
    navigation_label "Data"
  end

  config.model HelpMessage do
    navigation_label "Transmitted"
  end

  config.model Lesson do
    navigation_label "Configuration"
  end

  config.model Login do
    navigation_label "Transmitted"

    list do
      field :participant
      field :logged_in_at
      field :app_version
    end
  end

  config.model NurseTask do
    navigation_label "Data"

    list do
      field :nurse do
        pretty_value do
          value.try(:email)
        end
      end
      field :participant do
        searchable :study_identifier
      end
      field :type
      field :status
      field :scheduled_at
      field :overdue_at
    end

    edit do
      field :participant do
        read_only true
      end
      field :status
      field :scheduled_at do
        strftime_format "%Y-%m-%d %H:%M"
      end
      field :overdue_at do
        read_only true
      end
    end
  end

  config.model Participant do
    navigation_label "Management"

    object_label_method :study_id

    list do
      field :nurse
      field :last_and_first_name
      field :phone
      field :study_identifier
      field :phone_identifier
      field :tokens do
        pretty_value do
          participant_id = bindings[:object].id

          status = if TokenAuth::ConfigurationToken.exists?(entity_id: participant_id)
                     "[pending]"
                   elsif TokenAuth::AuthenticationToken.exists?(entity_id: participant_id)
                     "[configured]"
                   else
                     ""
                   end

          ("<a href=\"/entities/#{ participant_id }/tokens?locale=#{ bindings[:view].current_user.locale }\">Show</a> " + status).html_safe
        end
      end
      field :locale
    end

    edit do
      field :first_name
      field :last_name
      field :phone
      field :study_identifier
      field :status
    end
  end

  def study_id
    return "#{self.study_identifier}"
  end

  config.model ParticipantStartDate do
    navigation_label "Transmitted"
  end

  config.model PatientContact do
    navigation_label "Data"
  end

  config.model PlannedActivity do
    navigation_label "Transmitted"
  end

  config.model Response do
    navigation_label "Transmitted"
  end

  config.model SessionEvent do
    navigation_label "Transmitted"
  end

  config.model Smartphone do
    navigation_label "Data"
  end

  config.model User do
    navigation_label "Management"

    object_label_method :email

    list do
      field :role
      field :first_name
      field :last_name
      field :phone
      field :locale
    end
  end

  def email
    return "#{self.email}"
  end

  config.model FirstContact do
    navigation_label "Data"

    list do
      field :participant
      field :first_appointment_at
    end
  end

  config.model FirstAppointment do
    navigation_label "Data"

    list do
      field :participant
      field :appointment_at
    end
  end

  config.model Nurse do
    object_label_method :last_and_first_name

    edit do
      field :email
      field :phone
      field :first_name
      field :last_name
      field :password
      field :password_confirmation
      field :nurse_supervisor do
        associated_collection_cache_all false
        associated_collection_scope do
          if bindings[:view]
            locale = bindings[:view].current_user.locale
            Proc.new { |scope|
              scope = scope.where(locale: locale)
            }
          end
        end
      end
      field :family_health_unit_name, :enum do
        enum { I18n.t("conemo.family_health_units") }
      end
      field :locale, :hidden do
        default_value do
          bindings[:view].current_user.locale
        end
      end
      field :timezone, :hidden do
        default_value do
          bindings[:view].current_user.timezone
        end
      end
      field :role, :hidden do
        default_value do
          "nurse"
        end
      end
    end
  end

  config.model NurseSupervisor do
    object_label_method do
      :last_and_first_name
    end

    edit do
      field :email
      field :phone
      field :first_name
      field :last_name
      field :locale, :hidden do
        default_value do
          bindings[:view].current_user.locale
        end
      end
      field :timezone, :hidden do
        default_value do
          bindings[:view].current_user.timezone
        end
      end
      field :role, :hidden do
        default_value do
          "nurse_supervisor"
        end
      end
    end
  end

  config.model SecondContact do
    navigation_label "Data"

    list do
      field :participant
      field :contact_at
    end
  end

  config.model ThirdContact do
    navigation_label "Data"

    list do
      field :participant
      field :contact_at
    end
  end

  config.model TokenAuth::AuthenticationToken do
    navigation_label "Management"

    list do
      field :entity_id do
        label "Participant"
        pretty_value do
          Participant.find_by_id(value).try(:study_identifier)
        end
      end
      field :is_enabled
      field :client_uuid
    end
  end
end

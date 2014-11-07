RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authorize_with do
    redirect_to main_app.root_path unless warden.user.admin?
  end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    export
    new do
      only [User]
    end
    edit do
      only [User]
    end
    bulk_delete
    show
    delete
    show_in_app

    config.included_models = [User, Participant, ReminderMessage, FirstContact, FirstAppointment, SecondContact, ThirdContact]

    config.model User do

      object_label_method :email

      list do
        field :role
        field :first_name
        field :last_name
        field :phone
      end

      edit do
        field :role, :enum do
          enum do
            ['nurse', 'admin']
          end
        end
        field :email
        field :first_name
        field :last_name
        field :phone
        field :locale, :enum do
          enum do
            ['en', 'pt-BR', 'es-PE']
          end
        end
        field :password
        field :password_confirmation
      end
    end

    def email
      return "#{self.email}"
    end

    config.model Participant do
      object_label_method :study_id

      list do
        field :nurse
        field :first_name
        field :last_name
        field :phone
        field :study_identifier
        field :locale
      end

      edit do
        field :first_name
        field :last_name
        field :phone
        field :study_identifier
        field :locale
        field :start_date
      end
    end
  end

  def study_id
    return "#{self.study_identifier}"
  end

  config.model FirstContact do
    list do
      field :participant
      field :first_appointment_at
    end
  end

  config.model FirstAppointment do
    list do
      field :participant
      field :next_contact
    end
  end

  config.model SecondContact do
    list do
      field :participant
      field :next_contact
    end
  end

  config.model ThirdContact do
    list do
      field :participant
      field :final_appointment_at
    end
  end
end

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
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    config.included_models = [User, Participant, ReminderMessage]

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


  end
end

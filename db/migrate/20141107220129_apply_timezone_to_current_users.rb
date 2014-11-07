class ApplyTimezoneToCurrentUsers < ActiveRecord::Migration
  def up
    users = User.all

   users.each do |u|
      if !u.timezone

        case u.locale

        when "en"
            u.timezone = "Central Time (US & Canada)"
            u.save
        when "pt-BR"
            u.timezone = "Brasilia"
            u.save
        when "es-PE"
            u.timezone = "Lima"
            u.save
        else
            return
        end
      end
    end
  end
end

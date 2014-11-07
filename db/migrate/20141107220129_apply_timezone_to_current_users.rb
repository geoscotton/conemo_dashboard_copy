class ApplyTimezoneToCurrentUsers < ActiveRecord::Migration
  def up
    users = User.all

   users.each do |u|
      if !u.timezone

        case u.locale

        when "en"
            u.timezone = "Central Time (US & Canada)"
        when "pt-BR"
            u.timezone = "Brasilia"
        when "es-PE"
            u.timezone = "Lima"
        else
            return
        end
      end
    end
  end
end

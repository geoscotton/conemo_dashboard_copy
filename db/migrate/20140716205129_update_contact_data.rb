class UpdateContactData < ActiveRecord::Migration
  def up
    first_appointments = FirstAppointment.all

    first_appointments.each do |fa|
      if !fa.next_contact
        fa.next_contact = fa.appointment_at + 1.weeks
        fa.save
      end
    end

    second_contacts = SecondContact.all

    second_contacts.each do |sc|
      if !sc.next_contact
        sc.next_contact = sc.contact_at + 3.weeks
        sc.save
      end
    end
  end
end
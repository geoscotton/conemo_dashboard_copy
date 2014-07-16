class UpdateThirdContactData < ActiveRecord::Migration
  def up
    third_contacts = ThirdContact.all

    third_contacts.each do |tc|
      if !tc.contact_at
        tc.contact_at = tc.participant.second_contact.next_contact
        tc.save
      end
    end
  end
end

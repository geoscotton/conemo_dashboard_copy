User.create!(
  email: "admin1@example.com",
  password: "secrets!",
  password_confirmation: "secrets!",
  role: "admin",
  phone: "555-555-5555",
  first_name: "David",
  last_name: "Shing",
  locale: "en"
)
User.create!(
  email: "nurse1@example.com",
  password: "secrets!",
  password_confirmation: "secrets!",
  role: "nurse",
  phone: "555-555-5555",
  first_name: "Linda",
  last_name: "Ratchet",
  locale: "en"
)
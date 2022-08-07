User.create!(
  email: 'admin@example.com',
  password: 'foobar',
  password_confirmation: 'foobar'
)

30.times do
  Course.create!([{
                    title: Faker::Educator.course_name,
                    description: Faker::TvShows::GameOfThrones.quote,
                    user: User.find_by(email: "admin@example.com")
                  }])
end
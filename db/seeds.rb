# frozen_string_literal: true

# admin = User.create!(
#   email: 'admin@example.com',
#   password: 'foobar',
#   password_confirmation: 'foobar',
#   confirmed_at: Time.zone.now,
# )
# admin.add_role(:admin) unless admin.has_role?(:admin)

User.create!(
  email: 'foo@bar.com',
  password: 'foobar',
  password_confirmation: 'foobar',
  confirmed_at: Time.zone.now
)
# user.skip_confirmation!
# user.save!

# Отключить активность, чтобы не было ошибок при создании курсов
PublicActivity.enabled = false

30.times do
  Course.create!([{
                   title: Faker::Educator.course_name,
                   description: Faker::TvShows::GameOfThrones.quote,
                   user_id: User.first.id,
                   short_description: Faker::Quote.famous_last_words,
                   language: 'English',
                   level: 'Beginner',
                   price: Faker::Number.between(from: 1000, to: 20_000)
                 }])
end

PublicActivity.enabled = true

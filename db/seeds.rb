# frozen_string_literal: true

if User.find_by(email: 'admin@example.com').nil?
  admin = User.create!(email: 'admin@example.com', password: 'foobar', password_confirmation: 'foobar', confirmed_at: Time.zone.now)
  # admin.skip_confirmation!
  admin.add_role(:admin) unless admin.has_role?(:admin)
  admin.add_role(:teacher) unless admin.has_role?(:teacher)
end

if User.find_by(email: 'teacher@example.com').nil?
  teacher = User.create!(email: 'teacher@example.com', password: 'foobar', password_confirmation: 'foobar', confirmed_at: Time.zone.now)
  # teacher.skip_confirmation!
  teacher.add_role(:teacher) unless teacher.has_role?(:teacher)
  teacher.add_role(:student) unless teacher.has_role?(:student)
end

if User.find_by(email: 'student@example.com').nil?
  student = User.create!(email: 'student@example.com', password: 'foobar', password_confirmation: 'foobar', confirmed_at: Time.zone.now)
  # student.skip_confirmation!
  student.add_role(:student) unless student.has_role?(:student)
end

# Отключить активность, чтобы не было ошибок при создании курсов
PublicActivity.enabled = false

5.times do
  Course.create!([{
                   title: Faker::Educator.course_name,
                   short_description: Faker::Quote.famous_last_words,
                   description: Faker::TvShows::GameOfThrones.quote,
                   user: User.find_by(email: 'admin@example.com'),
                   language: 'English',
                   level: 'All levels',
                   price: Faker::Number.between(from: 1000, to: 20_000),
                   # price: 0,
                   approved: true,
                   published: true
                 }])
end

5.times do
  Course.create!([{
                   title: Faker::Educator.course_name,
                   short_description: Faker::Quote.famous_last_words,
                   description: Faker::TvShows::GameOfThrones.quote,
                   user: User.find_by(email: 'teacher@example.com'),
                   language: Faker::ProgrammingLanguage.name,
                   level: 'Beginner',
                   # price: Faker::Number.between(from: 1000, to: 20000),
                   price: 0,
                   approved: true,
                   published: true
                 }])
end


Course.all.each do |course|
  10.times do
    Lesson.create!([{
                      title: Faker::Lorem.sentence(word_count: 3),
                      content: Faker::Lorem.sentence,
                      course: course
                    }])
  end
end

#   Enrollment.create!([{
#                         user: User.find_by(email: "teacher@example.com"),
#                         course: course
#                       }])
#
#   Enrollment.create!([{
#                         user: User.find_by(email: "student@example.com"),
#                         course: course,
#                         price: course.price
#                       }])
# end

PublicActivity.enabled = true

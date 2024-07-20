# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

  return unless Rails.env.development?

  User.destroy_all

  User.create!(name: 'Andrej', email: 'andrej@mail.test', city: 'Glasgow', created_at: '2013-09-19 22:20:19')
  User.create!(name: 'Juraj', email: 'juraj@mail.test', city: 'Praha', created_at: '2013-09-19 22:20:34')
  User.create!(name: 'Jožko', email: 'jozko@mail.test', city: 'Bratislava', created_at: '2013-09-19 22:21:04')
  User.create!(name: 'Peter', email: 'peter@mail.test', city: 'Brno', created_at: '2013-09-19 22:21:17')
  User.create!(name: 'Jon', email: 'jon@mail.test', city: 'New York', created_at: '2013-09-19 22:21:41')

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# create user for testing
user = User.create(email: "raul@um.es", password: "123456", password_confirmation: "123456", confirmed_at: Time.now.utc, approved: true)
user.add_role(:admin)

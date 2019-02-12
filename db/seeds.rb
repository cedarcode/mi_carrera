# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  ["Cálculo 1", 13],
  ["Geometría y Álgebra Lineal 1", 9],
  ["Física 1", 10]
].each do |course_data|
  Course.create!(name: course_data[0], credits: course_data[1])
end

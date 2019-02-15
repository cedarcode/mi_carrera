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
  ["Física 1", 10],
  ["Cálculo 2", 16],
  ["Geometría y Álgebra Lineal 2", 9],
  ["Matemática Discreta 1", 9],
  ["Programación 1", 10],
  ["Probabilidad y Estádistica", 10],
  ["Matemática Discreta 2", 9],
  ["Lógica", 12],
  ["Programación 2", 12],
  ["Economía", 7],
  ["Programación 3", 15],
  ["Arquitectura de Computadoras", 12],
  ["Politicas Científicas en Información y Computación", 3],
  ["Métodos Numéricos", 8],
  ["Introducción a la Investigación de Operaciones", 10],
  ["Teoría de Lenguajes", 12],
  ["Sistemas Operativos", 12],
  ["Programación 4", 15],
  ["Ciencia Tecnología y Sociedad", 8],
  ["Administración General para Ingenieros", 5],
  ["Gestión de Calidad", 6],
  ["Fundamentos de Base de Datos", 15],
  ["Taller de Programación", 15],
  ["Práctica de Administración para Ingenieros", 5],
  ["Redes de Computadoras", 12],
  ["Control de Calidad", 8],
  ["Introducción a la Ingeniería de Software", 10],
  ["Proyecto de Ingeniería de Software", 15]
].each do |course_data|
  Course.where(name: course_data[0]).first_or_create.update!(credits: course_data[1])
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  ["Cálculo 1", 13, 1],
  ["Geometría y Álgebra Lineal 1", 9, 1, "GAL 1"],
  ["Física 1", 10, 1],
  ["Cálculo 2", 16, 2],
  ["Geometría y Álgebra Lineal 2", 9, 2, "GAL 2"],
  ["Matemática Discreta 1", 9, 2],
  ["Programación 1", 10, 2],
  ["Probabilidad y Estádistica", 10, 3],
  ["Matemática Discreta 2", 9, 3],
  ["Lógica", 12, 3],
  ["Programación 2", 12, 3],
  ["Economía", 7, 4],
  ["Programación 3", 15, 4],
  ["Arquitectura de Computadoras", 12, 4],
  ["Politicas Científicas en Información y Computación", 3, 4, "Políticas Científicas en Inf. y Comp."],
  ["Métodos Numéricos", 8, 4],
  ["Introducción a la Investigación de Operaciones", 10, 5, "IIO"],
  ["Teoría de Lenguajes", 12, 5],
  ["Sistemas Operativos", 12, 5],
  ["Programación 4", 15, 5],
  ["Ciencia Tecnología y Sociedad", 8, 5],
  ["Administración General para Ingenieros", 5, 5, "AGPI"],
  ["Gestión de Calidad", 6, 5],
  ["Fundamentos de Base de Datos", 15, 6],
  ["Taller de Programación", 15, 6],
  ["Práctica de Administración para Ingenieros", 5, 6, "PAI"],
  ["Redes de Computadoras", 12, 6],
  ["Control de Calidad", 8, 6],
  ["Introducción a la Ingeniería de Software", 10, 7, "IIS"],
  ["Proyecto de Ingeniería de Software", 15, 8, "PIS"]
].each do |subject_data|
  Subject.where(name: subject_data[0]).first_or_create.update!(credits: subject_data[1], semester: subject_data[2], short_name: subject_data[3])
end

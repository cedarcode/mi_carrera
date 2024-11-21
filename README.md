# MiCarrera

Sistema de trackeo de materias realizadas para los estudiantes de Computación de la FING con el objetivo de que el manejo de las materias, previaturas y el avance de carrera sea más fácil y claro.

### Requisitos

* Ruby 3.3.6
* PostgreSQL (preferentemente v14)

### Setup

```
$ git clone https://github.com/cedarcode/mi_carrera.git
$ cd mi_carrera/
$ bundle install
$ bin/rails db:setup
$ bin/rails load_yml
```

### Levantar el servidor

```
$ bin/rails s
```

Una vez hecho esto podés entrar a http://localhost:3000 y usar la aplicación normalmente.

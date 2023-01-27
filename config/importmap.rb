# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "install", to: "install.js"
pin "serviceworker-companion", to: "serviceworker-companion.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
pin "@material/dialog", to: "https://ga.jspm.io/npm:@material/dialog@3.2.0/dist/mdc.dialog.js"
pin "@material/drawer", to: "https://ga.jspm.io/npm:@material/drawer@3.2.0/dist/mdc.drawer.js"
pin "@material/textfield", to: "https://ga.jspm.io/npm:@material/textfield@3.2.0/dist/mdc.textfield.js"
pin "@material/snackbar", to: "https://ga.jspm.io/npm:@material/snackbar@3.2.0/dist/mdc.snackbar.js"
pin_all_from "app/javascript/controllers", under: "controllers"

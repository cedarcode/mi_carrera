# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "install", to: "install.js"
pin "serviceworker-companion", to: "serviceworker-companion.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@material/banner", to: "https://ga.jspm.io/npm:@material/banner@14.0.0/index.js"
pin "@material/dom/focus-trap", to: "https://ga.jspm.io/npm:@material/dom@14.0.0/focus-trap.js"
pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.6.0/dist/confetti.module.mjs"

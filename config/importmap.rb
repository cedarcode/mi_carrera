# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "install", to: "install.js"
pin "serviceworker-companion", to: "serviceworker-companion.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
pin "@material/drawer", to: "https://ga.jspm.io/npm:@material/drawer@14.0.0/dist/mdc.drawer.js"
pin "@material/textfield", to: "https://ga.jspm.io/npm:@material/textfield@14.0.0/dist/mdc.textfield.js"
pin "@material/snackbar", to: "https://ga.jspm.io/npm:@material/snackbar@14.0.0/dist/mdc.snackbar.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@material/banner", to: "https://ga.jspm.io/npm:@material/banner@14.0.0/index.js"
pin "@material/base/component", to: "https://ga.jspm.io/npm:@material/base@14.0.0/component.js"
pin "@material/base/foundation", to: "https://ga.jspm.io/npm:@material/base@14.0.0/foundation.js"
pin "@material/dom/focus-trap", to: "https://ga.jspm.io/npm:@material/dom@14.0.0/focus-trap.js"
pin "@material/dom/ponyfill", to: "https://ga.jspm.io/npm:@material/dom@14.0.0/ponyfill.js"
pin "tslib", to: "https://ga.jspm.io/npm:tslib@2.5.3/tslib.es6.mjs"
pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.6.0/dist/confetti.module.mjs"
pin "@material/menu", to: "https://ga.jspm.io/npm:@material/menu@14.0.0/index.js"
pin "@material/animation/util", to: "https://ga.jspm.io/npm:@material/animation@14.0.0/util.js"
pin "@material/dom/keyboard", to: "https://ga.jspm.io/npm:@material/dom@14.0.0/keyboard.js"
pin "@material/list/component", to: "https://ga.jspm.io/npm:@material/list@14.0.0/component.js"
pin "@material/list/constants", to: "https://ga.jspm.io/npm:@material/list@14.0.0/constants.js"
pin "@material/list/foundation", to: "https://ga.jspm.io/npm:@material/list@14.0.0/foundation.js"
pin "@material/menu-surface/component", to: "https://ga.jspm.io/npm:@material/menu-surface@14.0.0/component.js"
pin "@material/menu-surface/constants", to: "https://ga.jspm.io/npm:@material/menu-surface@14.0.0/constants.js"
pin "@material/menu-surface/foundation", to: "https://ga.jspm.io/npm:@material/menu-surface@14.0.0/foundation.js"

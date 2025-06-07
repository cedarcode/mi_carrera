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
pin "tslib", to: "https://ga.jspm.io/npm:tslib@2.5.3/tslib.es6.mjs"
pin "@material/base/component", to: "https://ga.jspm.io/npm:@material/base@14.0.0/component.js"
pin "@material/base/foundation", to: "https://ga.jspm.io/npm:@material/base@14.0.0/foundation.js"
pin "@material/dom/ponyfill", to: "https://ga.jspm.io/npm:@material/dom@14.0.0/ponyfill.js"
pin "@github/webauthn-json/browser-ponyfill", to: "@github--webauthn-json--browser-ponyfill.js"
pin "stub_credentials" if Rails.env.test?

# sinon
pin "sinon", to: "https://cdn.jsdelivr.net/npm/sinon@15.2.0/pkg/sinon-esm.js"

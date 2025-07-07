# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "install", to: "install.js"
pin "serviceworker-companion", to: "serviceworker-companion.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.6.0/dist/confetti.module.mjs"
pin "choices.js", to: "https://ga.jspm.io/npm:choices.js@11.1.0/public/assets/scripts/choices.js"
pin "@github/webauthn-json/browser-ponyfill", to: "@github--webauthn-json--browser-ponyfill.js"

if Rails.env.test?
  pin "stub_credentials"
  pin "sinon" # @20.0.0
end
pin "sortablejs" # @1.15.6
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.12

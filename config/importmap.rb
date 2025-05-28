# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "install", to: "install.js"
pin "serviceworker-companion", to: "serviceworker-companion.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
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
pin "@github/webauthn-json", to: "https://ga.jspm.io/npm:@github/webauthn-json@2.1.1/dist/esm/webauthn-json.js"
pin "credential", to: "credential.js"
pin "stub_credentials" if Rails.env.test?

# sinon
pin "sinon", to: "https://ga.jspm.io/npm:sinon@9.0.2/lib/sinon.js"
pin "@sinonjs/commons", to: "https://ga.jspm.io/npm:@sinonjs/commons@1.8.6/lib/index.js"
pin "@sinonjs/fake-timers", to: "https://ga.jspm.io/npm:@sinonjs/fake-timers@6.0.1/src/fake-timers-src.js"
pin "@sinonjs/formatio", to: "https://ga.jspm.io/npm:@sinonjs/formatio@5.0.1/lib/formatio.js"
pin "@sinonjs/samsam", to: "https://ga.jspm.io/npm:@sinonjs/samsam@5.3.1/lib/samsam.js"
pin "@sinonjs/text-encoding", to: "https://ga.jspm.io/npm:@sinonjs/text-encoding@0.7.2/index.js"
pin "diff", to: "https://ga.jspm.io/npm:diff@4.0.2/dist/diff.js"
pin "isarray", to: "https://ga.jspm.io/npm:isarray@0.0.1/index.js"
pin "just-extend", to: "https://ga.jspm.io/npm:just-extend@4.2.1/index.js"
pin "lodash.get", to: "https://ga.jspm.io/npm:lodash.get@4.4.2/index.js"
pin "nise", to: "https://ga.jspm.io/npm:nise@4.1.0/lib/index.js"
pin "path-to-regexp", to: "https://ga.jspm.io/npm:path-to-regexp@1.9.0/index.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
pin "supports-color", to: "https://ga.jspm.io/npm:supports-color@7.2.0/browser.js"
pin "type-detect", to: "https://ga.jspm.io/npm:type-detect@4.0.8/type-detect.js"
pin "util", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/util.js"

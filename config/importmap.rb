# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "install", to: "install.js"
pin "devise/webauthn", to: "devise/webauthn.js"
pin "serviceworker-companion", to: "serviceworker-companion.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.6.0/dist/confetti.module.mjs"
pin "choices.js", to: "https://ga.jspm.io/npm:choices.js@11.1.0/public/assets/scripts/choices.js"

pin "sortablejs" # @1.15.6
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.12

# Graph visualization for subject dependencies
pin "cytoscape" # @3.33.1
pin "cytoscape-dagre" # @2.5.0
pin "dagre" # @0.8.5
pin "graphlib" # @2.1.8
pin "lodash/clone", to: "lodash--clone.js" # @4.17.23
pin "lodash/cloneDeep", to: "lodash--cloneDeep.js" # @4.17.23
pin "lodash/constant", to: "lodash--constant.js" # @4.17.23
pin "lodash/defaults", to: "lodash--defaults.js" # @4.17.23
pin "lodash/each", to: "lodash--each.js" # @4.17.23
pin "lodash/filter", to: "lodash--filter.js" # @4.17.23
pin "lodash/find", to: "lodash--find.js" # @4.17.23
pin "lodash/flatten", to: "lodash--flatten.js" # @4.17.23
pin "lodash/forEach", to: "lodash--forEach.js" # @4.17.23
pin "lodash/forIn", to: "lodash--forIn.js" # @4.17.23
pin "lodash/has", to: "lodash--has.js" # @4.17.23
pin "lodash/isArray", to: "lodash--isArray.js" # @4.17.23
pin "lodash/isEmpty", to: "lodash--isEmpty.js" # @4.17.23
pin "lodash/isFunction", to: "lodash--isFunction.js" # @4.17.23
pin "lodash/isUndefined", to: "lodash--isUndefined.js" # @4.17.23
pin "lodash/keys", to: "lodash--keys.js" # @4.17.23
pin "lodash/last", to: "lodash--last.js" # @4.17.23
pin "lodash/map", to: "lodash--map.js" # @4.17.23
pin "lodash/mapValues", to: "lodash--mapValues.js" # @4.17.23
pin "lodash/max", to: "lodash--max.js" # @4.17.23
pin "lodash/merge", to: "lodash--merge.js" # @4.17.23
pin "lodash/min", to: "lodash--min.js" # @4.17.23
pin "lodash/minBy", to: "lodash--minBy.js" # @4.17.23
pin "lodash/now", to: "lodash--now.js" # @4.17.23
pin "lodash/pick", to: "lodash--pick.js" # @4.17.23
pin "lodash/range", to: "lodash--range.js" # @4.17.23
pin "lodash/reduce", to: "lodash--reduce.js" # @4.17.23
pin "lodash/size", to: "lodash--size.js" # @4.17.23
pin "lodash/sortBy", to: "lodash--sortBy.js" # @4.17.23
pin "lodash/transform", to: "lodash--transform.js" # @4.17.23
pin "lodash/union", to: "lodash--union.js" # @4.17.23
pin "lodash/uniqueId", to: "lodash--uniqueId.js" # @4.17.23
pin "lodash/values", to: "lodash--values.js" # @4.17.23
pin "lodash/zipObject", to: "lodash--zipObject.js" # @4.17.23

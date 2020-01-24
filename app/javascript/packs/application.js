/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker')

import "install"
import "serviceworker-companion"
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

import CreditsCounter from "../components/CreditsCounter";
import Bedel from "../components/Bedel";
import React from "react";
import ReactDOM from "react-dom";

const application = Application.start()
const context = require.context("controllers", true, /.js$/)
application.load(definitionsFromContext(context))

document.addEventListener("turbolinks:load", function() {
  window.initializeCheckboxes();

  let creditsCounterContainer = document.querySelector(".js-credits-count");
  let creditsCount = creditsCounterContainer.dataset.count;

  ReactDOM.render(
    React.createElement(CreditsCounter, { count: creditsCount }),
    creditsCounterContainer
  );

  const subjects = [
    { name: 'CAL1', path: '/subjects/1', has_exam: true, can_enroll_to_exam: true },
    { name: 'GAL1', path: '/subjects/2', has_exam: true, can_enroll_to_exam: false },
    { name: 'PROG1', path: '/subjects/3' }
  ]

  ReactDOM.render(
    React.createElement(Bedel, { subjects }),
    document.querySelector('.js-bedel')
  );
});

window.initializeCheckboxes = function() {
  document.querySelectorAll(".mdc-checkbox").forEach(function(element) {
    element.addEventListener("click", function(event) {
      event.stopPropagation();
    });
  });
};

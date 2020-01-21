import { Controller } from "stimulus"
import CreditsCounter from "../components/CreditsCounter";
import React from "react";
import ReactDOM from "react-dom";

export default class extends Controller {
  update() {
    Rails.fire(this.element, 'submit');
  }

  notifyCreditsChange(event) {
    let count = event.detail[0]["credits"];

    ReactDOM.render(
      React.createElement(CreditsCounter, { count }),
      document.querySelector(".js-credits-count")
    );
  }
}

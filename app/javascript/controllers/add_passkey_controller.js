import { Controller } from "@hotwired/stimulus"
import * as Credential from "credential";

export default class extends Controller {
  create(event) {
    var [data, status, xhr] = event.detail;
    var credentialOptions = data;
    var credential_name = event.target.querySelector("input[name='credential[name]']").value;
    var callback_url = `/usuarios/passkeys/callback?credential_name=${credential_name}`

    //Server knows identity of the user asking this passkey
    Credential.create(encodeURI(callback_url), credentialOptions);
  }
}

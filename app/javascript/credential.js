import * as WebAuthnJSON from "@github/webauthn-json"

function getCSRFToken() {
  var CSRFSelector = document.querySelector('meta[name="csrf-token"]')
  if (CSRFSelector) {
    return CSRFSelector.getAttribute("content")
  } else {
    return null
  }
}

function callback(url, body) {
  fetch(url, {
    method: "POST",
    body: JSON.stringify(body),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": getCSRFToken()
    },
    credentials: 'same-origin'
  }).then(function(response) {
    if (response.ok) {
      window.location.replace("/usuarios/passkeys")
    } else if (response.status < 500) {
      response.text().then(text => alert(text));
    } else {
      alert("Ocurrió un problema al registrar tu passkey");
    }
  });
}

function create(callbackUrl, credentialOptions) {
  WebAuthnJSON.create({ "publicKey": credentialOptions }).then(function(credential) {
    callback(callbackUrl, credential);
  }).catch(error => {
    if (error.name === "NotAllowedError") {
      alert("No seleccionaste el autenticador o cancelaste la operación.");
    } else if (error.name === "InvalidStateError") {
      alert("Ya registraste esta passkey con tu cuenta.");
    } else {
      alert(error.message || error);
    }
  });

  console.log("Creating new public key credential...");
}

function get(credentialOptions) {
  WebAuthnJSON.get({ "publicKey": credentialOptions }).then(function(credential) {
    callback("/session/callback", credential);
  }).catch(error => {
      alert(error);
  });

  console.log("Getting public key credential...");
}

export { create, get }

module Support
  module StubPasskeys
    def stub_create(fake_credential)
      # Encode binary fields to use in script
      encode(fake_credential, 'rawId')
      encode(fake_credential['response'], 'attestationObject')

      # Parse to avoid escaping already escaped characters
      fake_credential['response']['clientDataJSON'] = JSON.parse(fake_credential['response']['clientDataJSON'])

      page.execute_script(<<-SCRIPT)
        function encode(input) {
          return Uint8Array.from(input, c => c.charCodeAt(0));
        }

        let fakeCredential = JSON.parse('#{fake_credential.to_json}');

        fakeCredential.rawId = encode(atob(fakeCredential.rawId));
        fakeCredential.response.attestationObject = encode(atob(fakeCredential.response.attestationObject));
        fakeCredential.response.clientDataJSON = encode(JSON.stringify(fakeCredential.response.clientDataJSON));
        fakeCredential.getClientExtensionResults = function() { return {} };

        window.sinon.stub(navigator.credentials, 'create').resolves(fakeCredential);
      SCRIPT
    end

    def encode(hash, key)
      hash[key] = Base64.strict_encode64(hash[key])
    end
  end
end

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"
import "install";
import "serviceworker-companion";
import "devise/webauthn"

Turbo.session.drive = false

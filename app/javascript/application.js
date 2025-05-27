// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"
import "credential"
import Rails from "@rails/ujs";
import "install";
import "serviceworker-companion";

Rails.start();

Turbo.session.drive = false

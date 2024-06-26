class PwaController < ApplicationController
  skip_forgery_protection

  def manifest
    render template: "pwa/manifest", layout: false
  end
end

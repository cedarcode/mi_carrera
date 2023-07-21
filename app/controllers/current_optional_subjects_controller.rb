class CurrentOptionalSubjectsController < ApplicationController
  def index
    optional_subjects_codes = YAML.load_file(Rails.root.join('db', 'data', 'scraped_optional_subjects.yml'))
    @subjects = Subject.where(code: optional_subjects_codes).order(:code)

    respond_to do |format|
      format.html
    end
  end
end

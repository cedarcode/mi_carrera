module Features
  module ChangingDegrees
    module_function

    def enabled?
      ENV['ENABLE_CHANGING_DEGREES'].present?
    end
  end
end

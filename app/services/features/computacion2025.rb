module Features
  module Computacion2025
    module_function

    def enabled?
      ENV['ENABLE_COMPUTACION_2025'].present?
    end
  end
end

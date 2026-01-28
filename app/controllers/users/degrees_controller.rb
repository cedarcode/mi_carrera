module Users
  class DegreesController < ApplicationController
    before_action :ensure_feature_enabled!

    def edit; end

    def update
      current_student.degree = Degree.find(params[:degree_id])

      if current_student.save
        redirect_to root_path, notice: "Tu carrera ha sido actualizada correctamente."
      else
        redirect_to edit_user_degrees_path, alert: "Hubo un error actualizando tu carrera."
      end
    end

    private

    def ensure_feature_enabled!
      redirect_to root_path unless Features::ChangingDegrees.enabled?
    end
  end
end

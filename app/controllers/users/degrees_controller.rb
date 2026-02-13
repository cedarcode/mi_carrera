module Users
  class DegreesController < ApplicationController
    before_action :ensure_feature_enabled!

    def edit
      @degree = Degree.find_by(id: params[:degree_id]) || current_student.degree
      @degree_plans = @degree.degree_plans.order(:name)
    end

    def update
      current_student.degree_plan = DegreePlan.find(params[:degree_plan_id])

      if current_student.save
        redirect_to root_path, notice: "Tu plan ha sido actualizada correctamente."
      else
        redirect_to edit_user_degrees_path, alert: "Hubo un error actualizando tu plan."
      end
    end

    private

    def ensure_feature_enabled!
      redirect_to root_path unless Features::ChangingDegrees.enabled?
    end
  end
end

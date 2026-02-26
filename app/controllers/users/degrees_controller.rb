module Users
  class DegreesController < ApplicationController
    before_action :ensure_feature_enabled!

    def edit
      @degree_plans = DegreePlan.includes(:degree)
      @degree_plans = @degree_plans.where.not(degree_id: 'computacion', name: '2025') unless Features::Computacion2025.enabled?
      @degree_plans = @degree_plans.sort_by(&:display_name)
    end

    def update
      current_student.degree_plan = DegreePlan.find(params[:degree_plan_id])

      if current_student.save
        redirect_to root_path, notice: "Tu plan ha sido actualizado correctamente."
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

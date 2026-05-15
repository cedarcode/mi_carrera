module Users
  class DegreesController < ApplicationController
    def edit
      @degree_plans = DegreePlan.includes(:degree).sort_by(&:display_name)
    end

    def update
      current_student.degree_plan = DegreePlan.find(params[:degree_plan_id])

      if current_student.save
        redirect_to root_path, notice: "Tu plan ha sido actualizado correctamente."
      else
        redirect_to edit_user_degrees_path, alert: "Hubo un error actualizando tu plan."
      end
    end
  end
end

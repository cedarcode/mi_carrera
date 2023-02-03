class ApprovalsController < ApplicationController
  before_action :set_approvable

  def create
    bedel.add_approval(@approvable)
    render_turbo_stream
  end

  def destroy
    bedel.remove_approval(@approvable)
    render_turbo_stream
  end

  private

  def render_turbo_stream
    if params[:subject_show]
      @subject = @approvable.subject
    else
      @subjects = TreePreloader.new.preload.select { |subject| bedel.able_to_do?(subject.course) }
    end

    render :update
  end

  def set_approvable
    @approvable = Approvable.find(params[:approvable_id])
  end
end

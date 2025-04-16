module ViewComponentHelper
  def component(name, *args, **kwargs, &block)
    component = "#{name.to_s.camelize}Component".constantize
    render(component.new(*args, **kwargs), &block)
  end
end

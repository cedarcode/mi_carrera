class BedeliasPage
  attr_reader :browser
  delegate :find, :click_on, :all, :first, to: :browser

  def initialize(browser)
    @browser = browser
  end

  def visit_curriculum
    click_on "PLANES DE ESTUDIO"
    click_on "Planes de estudio / Previas"

    find("//h3[text()='TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA']").click
    find("//tr//span[text()='FING - FACULTAD DE INGENIERÍA']").click

    find("//td[text()='INGENIERIA EN COMPUTACION']/preceding-sibling::td/div").click
    find("//a[@id='datos1111:j_idt92:35:j_idt104:0:verComposicionPlan']").click
  end

  def visit_prerequisites
    visit_curriculum
    find("//button[span[text()='Sistema de previaturas']]").click
  end
end

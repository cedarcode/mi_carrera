class AddExtensionModuleToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :extension_module, :boolean
  end
end

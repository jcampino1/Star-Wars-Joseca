Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "consultas#index"

  get "consulta_especifica", to: "consultas#consulta_especifica", as: :consulta_especifica
  #get "persona", to: "consultas#persona", as: :persona

end



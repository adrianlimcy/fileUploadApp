Rails.application.routes.draw do
  resources :items
  controller :items do 
    get 'items/:id/download_pdf' => 'items#download_pdf'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

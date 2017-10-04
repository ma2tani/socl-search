Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'socls#search'
  get "search_result/init", to: 'search_result#init'
  get "search_result/result", to: 'search_result#result'
  get "socls/search"
end

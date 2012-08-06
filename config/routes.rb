NbaOnePage::Application.routes.draw do
  root :to => "aggregate_info#index"

  get 'rolled_data/:name(/:stat)' => "rolled_data#show"
  get 'boxscore/:team/:date' => "aggregate_info#boxscore"
end

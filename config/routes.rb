NbaOnePage::Application.routes.draw do
  root :to => "aggregate_info#index"

  get 'rolled_data/:name(/:stat)' => "rolled_data#show"
  get 'rolled_data_alt/:name(/:stat)' => "rolled_data_alt#show"
  get 'boxscore/:team/:date' => "aggregate_info#boxscore"


  #provide the capacity to clear the page cache remotely.
  #An Ironworker task clears the page cache after its done importing new data.
  get 'clear_cache' => "aggregate_info#clear_cache"
end

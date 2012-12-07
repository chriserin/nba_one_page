NbaOnePage::Application.routes.draw do
  root :to => "aggregate_info#index"

  get 'rolled_data/:name(/:stat)(/:year)' => "rolled_data#show"
  get 'boxscore/:team/:date' => "aggregate_info#boxscore"
  get 'test/' => "application#test"

  get ':team' => "aggregate_info#index"

  #provide the capacity to clear the page cache remotely.
  #An Ironworker task clears the page cache after its done importing new data.
  get 'clear_cache' => "aggregate_info#clear_cache"
end

NbaOnePage::Application.routes.draw do
  root :to => "aggregate_info#index"
  get 'rolled_data/:name/:stat/:year.json', :to => DataRollerApp
  get "playbyplay/:date/:name/:stat.json", :to => PlaybyplayApp

  get 'clear_cache' => "aggregate_info#clear_cache"
  get ':team' => "aggregate_info#team_info", :as => :team_info
  get ':team/stats/:split_type' => "aggregate_info#stats"
  get ':team/boxscore/:date' => "aggregate_info#boxscore"

  #provide the capacity to clear the page cache remotely.
  #An Ironworker task clears the page cache after its done importing new data.
end

NbaOnePage::Application.routes.draw do
  root :to => "aggregate_info#index"
  get 'rolled_data/:name/:stat/:year.json', :to => DataRollerApp
  get 'all_boxscores/:date' => "aggregate_info#all_boxscores"

  get 'boxscore/:team/:date' => "aggregate_info#boxscore"
  get 'test/' => "application#test"
  get 'clear_cache' => "aggregate_info#clear_cache"

  get ':team' => "aggregate_info#team_info"

  #provide the capacity to clear the page cache remotely.
  #An Ironworker task clears the page cache after its done importing new data.
end

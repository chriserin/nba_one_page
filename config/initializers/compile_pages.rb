if Rails.env.production?
  Rails.application.config.after_initialize do
    #make sure the routes are loaded before calling each page.
    Rails.application.reload_routes!
    app = ActionDispatch::Integration::Session.new(Rails.application)
    p app.get('/')
    Nba::TEAMS.each do |team_name, team|
      p team[:nickname]
      result = app.get "/#{URI.escape(team[:nickname])}"
      p result
    end
  end
end

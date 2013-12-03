class NbaOnePage.Models.RolledDataSplit
  constructor: (data, fromIndex, toIndex) ->
    @data = data
    @fromIndex = if fromIndex >= data.length then data.length - 1 else fromIndex
    @toIndex = toIndex

  totalComponentValues: =>
    results = {}
    for datum, index in @data when [@fromIndex..@toIndex].indexOf(index) >= 0
      values = datum['component_values']
      for key, value of values
        results[key] = results[key] || 0
        results[key] += value
    return results

  startDate: ->
    moment(@data[@fromIndex].date).format("MM/DD")

  endDate: ->
    moment(@data[@toIndex].date).format("MM/DD")

  gamesCount: ->
    gamesWithData = []
    gamesWithData = (datum for datum in @data[@fromIndex..@toIndex] when datum.averaged_data? || datum.component_values?)
    gamesWithData.length

  calculate: (formula) ->
    formula ||= _.reject(@data, (v) -> v.formula == null)[0].formula
    switch formula
      when 'rolling_average'
        results = @totalComponentValues()
        values = (value for key, value of results)
        Math.round(values[0] / @gamesCount() * 10) / 10
      when 'free_throw_percentage', 'field_goal_percentage', 'threes_percentage'
        results = @totalComponentValues()
        values = (value for key, value of results)
        Math.round(values[0] / values[1] * 1000) / 1000
      else
        results = @totalComponentValues()
        @addPerMinuteMethods(results)
        results extends NbaOnePage.Models.StatFormulas.prototype
        console.log(results[formula])
        results[formula]()

  addPerMinuteMethods: (results) ->
    per_minutes_stat = _.reject(_.keys(results), (key) -> key.match(/minutes/))[0]
    if per_minutes_stat?
      results[per_minutes_stat + "_36"] = -> Math.round((this[per_minutes_stat] / @minutes * 36.0) * 10) / 10

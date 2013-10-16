describe 'RolledDataSplit', ->
  describe 'init', ->
    it 'should init', ->
      expect(new NbaOnePage.Models.RolledDataSplit([], 0, 1)).not.toBeNull('null')

  describe 'totalComponentValues', ->
    it 'should correctly total the values', ->
      data = [{'component_values': {'points': 10}}, {'component_values': {'points': 20}}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 1)
      results = split.totalComponentValues()
      chai.expect(results["points"]).to.equal(30)

    it 'should correctly total the values and handle nulls', ->
      data = [{'component_values': {'points': 10}}, {'component_values': null}, {'component_values': {'points': 20}}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 2)
      results = split.totalComponentValues()
      chai.expect(results["points"]).to.equal(30)

  describe 'startDate', ->
    it 'should return the start date', ->
      data = [{'date': '2013-03-24'}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 1)
      result = split.startDate()
      chai.expect(result).to.equal('03/24')

  describe 'endDate', ->
    it 'should return the endDate', ->
      data = [{'date': '2013-03-24'}, {'date': '2013-03-26'}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 1)
      result = split.endDate()
      chai.expect(result).to.equal('03/26')

  describe 'gamesCount', ->
    it 'should return the number of games in the split', ->
      data = [{'date': '2013-03-24', 'averaged_data': 1}, {'date': '2013-03-26', 'averaged_data': 1}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 1)
      result = split.gamesCount()
      chai.expect(result).to.equal(2)

    it 'should return the number of games in the split and handle nulls', ->
      data = [{'date': '2013-03-24', 'averaged_data': 1}, {'date': 'xxx', 'averaged_data': null}, {'date': '2013-03-26', 'averaged_data': 1}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 2)
      result = split.gamesCount()
      chai.expect(result).to.equal(2)

  describe 'calculate', ->
    it 'should calculate the value of the split given the formula', ->
      data = [{'component_values': {'points': 10}}, {'component_values': {'points': 20}}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 1)
      result = split.calculate('rolling_average')
      expect(result).toEqual(15)

    it 'should calculate the value of the split given a percentage formula', ->
      data = [{'component_values': {'made_field_goals': 10, 'attempted_field_goals': 20}}, {'component_values': {'made_field_goals': 20, 'attempted_field_goals': 30}}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 1)
      result = split.calculate('free_throw_percentage')
      chai.expect(result).to.equal(.60)

describe 'Array', ->
  describe '#indexOf()', ->
    it 'should return -1 when not present', ->
      chai.expect([1,2,3].indexOf(4)).to.equal(-1)

describe 'ViewFactory', ->
  describe 'create', ->
    it 'should create a view object', ->
      view = new NbaOnePage.ViewFactory().create(NbaOnePage.Views.StatTotals, {})
      chai.expect(view).to.be.an('object')

describe 'jQuery', ->
  describe 'fixture', ->
    it 'should be a div', ->
      expect($('<div id="some-id"></div>')).toBe('div')

Morris.Line::drawGrid = ->
  firstY = @ymin
  lastY = @ymax
  @yInterval = (@ymax - @ymin) / (@options.numLines - 1)

  if @yInterval > 0 and @yInterval < 1
    @precision =  -Math.floor(Math.log(@yInterval) / Math.log(10))
  else
    @precision = 0

  @yInterval = parseFloat(@yInterval.toFixed(@precision))
  count = 0

  for lineY in [firstY..lastY] by @yInterval
    v = lineY
    v = parseFloat(lineY.toFixed(@precision)) unless count == 0
    count++
    y = @transY(v)
    @raphael.text(@left - @options.padding / 2, y, @yAxisFormat(v))
      .attr('font-size', @options.gridTextSize)
      .attr('fill', @options.gridTextColor)
      .attr('text-anchor', 'end')
    @raphael.path("M#{@left},#{y}H#{@left + @width}")
      .attr('stroke', @options.gridLineColor)
      .attr('stroke-width', @options.gridStrokeWidth)

  if @ymin < 0 and @ymax > 0
    y = @transY(0)
    @raphael.text(@left - @options.padding / 2, y, @yAxisFormat(0))
      .attr('font-size', @options.gridTextSize)
      .attr('fill', 'black')
      .attr('text-anchor', 'end')
    @raphael.path("M#{@left},#{y}H#{@left + @width}")
      .attr('stroke', '#000000')
      .attr('stroke-width', @options.gridStrokeWidth)

Morris.Grid::transX = (x) ->
  return @left + (x - @xmin) * @dx

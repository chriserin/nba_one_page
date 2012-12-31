Morris.Line::drawGrid = ->
    firstY = @ymin
    lastY = @ymax
    @yInterval = parseFloat(@yInterval.toFixed(@precision))
    count = 0

    for lineY in [firstY..lastY] by @yInterval
      v = lineY
      v = parseFloat(lineY.toFixed(@precision)) unless count == 0
      count++
      y = @transY(v)
      @r.text(@left - @options.padding / 2, y, @yAxisFormat(v))
        .attr('font-size', @options.gridTextSize)
        .attr('fill', @options.gridTextColor)
        .attr('text-anchor', 'end')
      @r.path("M#{@left},#{y}H#{@left + @width}")
        .attr('stroke', @options.gridLineColor)
        .attr('stroke-width', @options.gridStrokeWidth)

NbaOnePage.Data.TotalStatGraphOptions = {
  colors: {'rgba(18, 50, 180, 1)'}
  shadowSize: 0;
  HtmlText : true,
  points: {
    show: true,
    radius: .2
  },
  lines: {show: true},
  xaxis : {
    mode : 'time',
    labelsAngle : 45
  },
  yaxis : {
    autoscale: true,
    autoscaleMargin : 1
  },
  selection : {
    mode : 'x'
  },
  mouse: {
    track: true,
    lineColor: 'purple',
    relative: true,
    position: 'ne',
    sensibility: 4,
    trackDecimals: 2,
    trackFormatter: (o) -> "#{o.series.data[o.index][2]}"
  },
  grid: {
    color: '#aaaaaa',
    backgroundColor: '#fcfcfc',
    backgroundImage: null,
    watermarkAlpha: 0.4,
    tickColor: '#DDDDDD',
    labelMargin: 9,
    verticalLines: true,
    minorVerticalLines: true,
    horizontalLines: true,
    minorHorizontalLines: true,
    outlineWidth: 2,
    outline : 'sw',
    circular: false
  }
}

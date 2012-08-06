(function(Flotr) {
    console.log(Flotr);
    Flotr.addPlugin('clickHit', {
        callbacks: {
            'flotr:click': function(e) {
                this.clickHit.clickHit(e);
            }
        },

        clickHit: function(mouse) {
            console.log(mouse);
            var closest = this.clickHit.closest(mouse);
            console.log(closest);
            $(".graph").trigger("graph:click", closest.x.dataIndex);
        },

        closest: function(mouse) {

            var
            series = this.series,
                options = this.options,
                mouseX = mouse.x,
                mouseY = mouse.y,
                compare = Number.MAX_VALUE,
                compareX = Number.MAX_VALUE,
                closest = {},
                closestX = {},
                check = false,
                serie, data, distance, distanceX, distanceY, x, y, i, j;

            function setClosest(o) {
                o.distance = distance;
                o.distanceX = distanceX;
                o.distanceY = distanceY;
                o.seriesIndex = i;
                o.dataIndex = j;
                o.x = x;
                o.y = y;
            }

            for (i = 0; i < series.length; i++) {

                serie = series[i];
                data = serie.data;

                if (data.length) check = true;

                for (j = data.length; j--;) {

                    x = data[j][0];
                    y = data[j][1];

                    if (x === null || y === null) continue;

                    distanceX = Math.abs(x - mouseX);
                    distanceY = Math.abs(y - mouseY);

                    // Skip square root for speed
                    distance = distanceX * distanceX + distanceY * distanceY;

                    if (distance < compare) {
                        compare = distance;
                        setClosest(closest);
                    }

                    if (distanceX < compareX) {
                        compareX = distanceX;
                        setClosest(closestX);
                    }
                }
            }

            return check ? {
                point: closest,
                x: closestX
            } : false;
        }
    });
})(Flotr);

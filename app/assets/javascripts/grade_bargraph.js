$(document).ready(function() {
   var dataset = $('#grade_bargraph').data('grades');
   var w = 600;
   var h = 250;
   var padding = 20;

   // Define scales
   var xScale = d3.scale.ordinal()
                  .domain(d3.range(dataset.length))
                  .rangeRoundBands([padding, w - padding * 2], 0.05)

   var yScale = d3.scale.linear()
                  .domain([0, d3.max(dataset)])
                  .range([padding, h - padding]);

   
   var svg = d3.select("#grade_bargraph")
               .append("svg")
               .attr("width", w)
               .attr("height", h);

   // Draw bars
   svg.selectAll("rect")
      .data(dataset)
      .enter()
      .append("rect")
      .attr("x", function(d, i) { return xScale(i); })
      .attr("y", function(d) { return h - padding - yScale(d); })
      .attr("width", xScale.rangeBand())
      .attr("height", function(d) { return yScale(d); })
      .attr("fill", "steelblue");

   // Define axes
   var xAxis = d3.svg.axis()
                  .scale(xScale)
                  .orient("bottom");

   var yAxis = d3.svg.axis()
                  .scale(yScale)
                  .orient("left");
   // Draw axes
   svg.append("g")
      .call(xAxis)
      .attr("transform", "translate(0, " + (h - padding) + ")");

   svg.append("g")
      .call(yAxis)
      .attr("transform", "translate(" + padding * 2 + ",0)");
});

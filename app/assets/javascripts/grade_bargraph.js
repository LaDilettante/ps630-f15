$(document).ready(function() {
   var bargraph_data = $('#grade_bargraph').data('finalgrades');
   var margin = {top: 20, right: 30, bottom: 30, left: 40};
   var width = 470 - margin.left - margin.right;
   var height = 300 - margin.top - margin.bottom;

   // Format float of 2 decimal
   var format = d3.format(".2f")

   // Define scales
   var xScale = d3.scale.ordinal()
                  .domain(d3.range(bargraph_data.length))
                  .rangeRoundBands([margin.left, margin.left + width], 0.05);

   var yScale = d3.scale.linear()
                  .domain([0, d3.max(bargraph_data)])
                  .range([margin.top + height, margin.top]);

   // Draw the svg canvas
   var svg = d3.select("#grade_bargraph")
               .append("svg")
               .attr("width", width + margin.left + margin.right)
               .attr("height", height + margin.top + margin.bottom);

   // Draw bars
   svg.selectAll("rect")
      .data(bargraph_data)
      .enter()
      .append("rect")
      .attr("x", function(d, i) { return xScale(i); })
      .attr("y", function(d) { return yScale(d); })
      .attr("width", xScale.rangeBand())
      .attr("height", function(d) { return margin.top + height - yScale(d); })
      .attr("fill", "steelblue")
      .on("mouseover", function() {
         d3.select(this)
            .attr("fill", "orange");
      })
      .on("mouseout", function() {
         d3.select(this)
            .transition()
            .duration(250)
            .attr("fill", "steelblue");
      });

   // Draw text label
   svg.selectAll("text")
      .data(bargraph_data)
      .enter()
      .append("text")
      .attr("x", function(d, i) { return xScale(i) + xScale.rangeBand() / 2; })
      .attr("y", function(d) { return yScale(d) + 15; })
      .attr("text-anchor", "middle")
      .attr("font-familty", "sans-serif")
      .style("pointer-events", "none")
      .text(function(d) { return format(d); });

   // Define axes
   var xAxis = d3.svg.axis()
                  .scale(xScale)
                  .ticks(5)
                  .orient("bottom");

   var yAxis = d3.svg.axis()
                  .scale(yScale)
                  .ticks(5)
                  .orient("left");
   // Draw axes
   svg.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(0, " + (margin.top + height) + ")")
      .call(xAxis);

   svg.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(" + margin.left + ", 0)")
      .call(yAxis)
      .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", - margin.left / 2)
      .style("text-anchor", "end")
      .text("Grade");
});

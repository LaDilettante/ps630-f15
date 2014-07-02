$(document).ready(function() {
  var scatterplot_data = $('#grade_scatterplot').data('submissions');
  // data is a list of list of 3 elements: title, grade, time

  var margin = {top: 20, right: 120, bottom: 30, left: 40};
  var width = 550 - margin.left - margin.right;
  var height = 300 - margin.top - margin.bottom;

  // Format float of 2 decimal
  var format = d3.format(".2f")

  // Define scales
  var xScale = d3.scale.linear()
                  .domain([
                    d3.min(scatterplot_data, function(d) { return d[2]; }) * 1.1, 
                    d3.max(scatterplot_data, function(d) { return d[2]; })
                  ])
                  .range([margin.left, margin.left + width]);

  var yScale = d3.scale.linear()
                  .domain([
                    0,
                    d3.max(scatterplot_data, function(d) { return d[1]; })
                  ])
                  .range([margin.top + height, margin.top]);

  // Draw the svg canvas
  var svg = d3.select("#grade_scatterplot")
              .append("svg")
              .attr("width", width + margin.left + margin.right)
              .attr("height", height + margin.bottom + margin.top);

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
      .attr("transform", "translate(0," + (margin.top + height) + ")")
      .call(xAxis)
      .append("text") // X axis label
      .attr("x", margin.left + width - 20)
      .attr("y", margin.bottom / 2)
      .text("Hours late");

  svg.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(" + margin.left + ", 0)")
      .call(yAxis)
      .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", - margin.left / 2)
      .style("text-anchor", "end")
      .text("Grade");

  
  
  // Draw bars
  svg.selectAll("circle")
      .data(scatterplot_data)
      .enter()
      .append("circle")
      .attr("cx", function(d) { return xScale(d[2]); })
      .attr("cy", function(d) { return yScale(d[1]); })
      .attr("r", 5)
      .attr("fill", "steelblue")
      .on("mouseover", function(d) {
        d3.select(this).attr("fill", "orange");

        var xPos = parseFloat(d3.select(this).attr("cx")) + 10;
        var yPos = parseFloat(d3.select(this).attr("cy")) - 10;

        var textblock = svg.append("text")
                            .attr("id", "tooltip")
                            .attr("x", xPos)
                            .attr("y", yPos)
                            .attr("font-size", "11px")
                            .attr("fill", "black");

        textblock.append("tspan")
                  .text(d[0])
                  .attr("x", xPos)
                  .attr("y", yPos);
        textblock.append("tspan")
                  .text("Grade: " + d[1])
                  .attr("x", xPos)
                  .attr("y", yPos + 10);
        textblock.append("tspan")
                  .text("Hours late: " + format(d[2]))
                  .attr("x", xPos)
                  .attr("y", yPos + 20);
      })
      .on("mouseout", function(d) {
        d3.select(this).attr("fill", "steelblue");
        d3.select("#tooltip").remove();
      });
});
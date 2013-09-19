$ ->

  width = 1500
  height = 1500

  svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height)

  window.sv = svg

  d3.json "/data/nl.json", (nl)->

    window.x = nl

    subunits = topojson.feature(nl, nl.objects.subunits)

    projection = d3.geo.albers()
      .center([4, 52.4])
      .rotate([4.4, 0])
      .parallels([50, 60])
      .scale(6000)
      .translate([width / 2, height / 2])

    path = d3.geo.path()
      .projection(projection)

    svg.append("path")
      .datum(subunits)
      .attr("d", path)

    svg.selectAll(".subunit")
      .data(topojson.feature(nl, nl.objects.subunits).features)
      .enter().append("path")
      .attr("class", ((d) -> "subunit " + d.id ))
      .attr("d", path)

    svg.append("path")
      .datum(topojson.mesh(nl, nl.objects.subunits, ((a, b)-> a isnt b ) ))
      .attr("d", path)
      .attr("class", "subunit-boundary")

    svg.append("path")
      .datum(topojson.feature(nl, nl.objects.places))
      .attr("d", path)
      .attr("class", "place")

    svg.selectAll(".place-label")
      .data(topojson.feature(nl, nl.objects.places).features)
      .enter().append("text")
      .attr("class", "place-label")
      .attr("transform", ((d)-> "translate(" + projection(d.geometry.coordinates) + ")"))
      .attr("dy", ".35em")
      .text((d)-> d.properties.name)

    svg.selectAll(".place-label")
      .attr("x", ((d)-> d.geometry.coordinates[0] > -1 ? 6 : -6))
      .style("text-anchor", ((d)-> d.geometry.coordinates[0] > -1 ? "start" : "end" ))













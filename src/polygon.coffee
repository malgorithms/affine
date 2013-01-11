affine = require './affine'
class polygon

  constructor: (vertices) ->
    if vertices?
      @vertices = vertices
    else
      @vertices = []

  copy: ->
    new_v = []
    new_v.push v.copy() for v in @vertices
    new polygon new_v

  addVertex: (v) -> @vertices.push v

  transform: (aff) ->
    aff.transformVec v for v in @vertices

  getBoundingRectangle: ->
    ###
    returns a pair of pairs; 
    for example: [[1,2],[3,5]] 
    means that  1 <= x <= 3
            and 2 <= y <= 5
    for all points 
    ###
    x = null
    for v,i in @vertices
      if (i is 0)
        x = [[v[0],v[1]],[v[0],v[1]]]
      else
        if v[0] < x[0][0] then x[0][0] = v[0]
        if v[0] > x[1][0] then x[1][0] = v[0]
        if v[1] < x[0][1] then x[0][1] = v[1]
        if v[1] > x[1][1] then x[1][1] = v[1]
    x

exports.polygon = polygon

exports.factory = 
  unitSquare: ->
    new polygon [
      [ 0.5,  0.5]
      [-0.5,  0.5]
      [-0.5, -0.5]
      [ 0.5, -0.5]
    ]
  unitCircleApprox: (num) ->
    radian_increment = 2.0 * Math.PI / num
    radians = 0
    p = new polygon()
    for i in [0...num]
      radians += radian_increment
      p.addVertex [0.5 * Math.cos(radians), 0.5 * Math.sin(radians)]
    p

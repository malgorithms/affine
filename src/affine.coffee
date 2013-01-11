
#
#   Chris Coyne, 2012. malgorithms@github
#
# Class for 2D affine transformations.
# A 2D affine transformation of a point P is
# defined by a 2*2 matrix (M) and a 2D translating vector (V) and is used to transform points like this::
#
# P' = M*P + V
#
# which executes like this:
#
# [ px' ]   [ M00 M01 ]   [ px ]   [ v0 ]
# [     ] = [         ] * [    ] + [    ] 
# [ py' ]   [ M10 M11 ]   [ py ]   [ v1 ]
#
# Commonly we represent the transformation as one matrix, like this:
#
# [ m00 m01 v0 ]
# [ m10 m11 v1 ]
#
# So we'll have 6 nums:
#
# m00,m01,m10,m11,v0,v1
#
#

exports.compose = (a1,a2) ->
  res = a2.copy()
  res.rightComposeWith a1
  res

class affine2d
  # Multiple ways to construct; check it below
	constructor: (args...) ->
    # if passed nothing, trivial affine
    if args.length == 0
      @m00 = 1
      @m01 = 0
      @m10 = 0
      @m11 = 1
      @v0  = 0
      @v1  = 0
    # if passed another affine, copy it
    else if args.length == 1
      @m00 = args[0].m00
      @m01 = args[0].m01
      @m10 = args[0].m10
      @m11 = args[0].m11
      @v0  = args[0].v0
      @v1  = args[0].v1
    # else expecting 6 components
    else
      @m00 = args[0]
      @m01 = args[1]
      @m10 = args[2]
      @m11 = args[3]
      @v0  = args[4]
      @v1  = args[5]

  oneLineSummary: ->
    "M = [#{@m00.toPrecision(3)}" +
      " #{@m01.toPrecision(3)}" +
      " #{@m10.toPrecision(3)}" +
      " #{@m11.toPrecision(3)}]   V = (" +
       "#{@v0.toPrecision(3)}, " +
      " #{@v1.toPrecision(3)})   scale = " +
      @getXScale().toPrecision(3) + " x " + 
      @getYScale().toPrecision(3)

  copy: -> new affine2d @

  transformPair: (v0, v1) ->
    # returns a pair array
    t0 = @m00 * v0 + @m01 * v1 + @v0
    t1 = @m10 * v0 + @m11 * v1 + @v1
    [t0, t1]

  transformVec: (a) ->
    # transforms a 2-item array in place
    t0 = @m00 * a[0] + @m01 * a[1] + @v0
    t1 = @m10 * a[0] + @m11 * a[1] + @v1
    a[0] = t0
    a[1] = t1

  rightComposeWith: (a) ->
    ###
    Typically when you have an affine A and you want to 
    perform another affine on it, use this.
    In other words:
      A.rightComposeWith(B)
      performs the composition B(A) and replaces A with the results.    
    ###
    t_m10 = a.m00 * @m10 + a.m10 * @m11
    t_m11 = a.m01 * @m10 + a.m11 * @m11
    t_v1  = a.v0  * @m10 + a.v1  * @m11 + @v1
    t_m00 = a.m00 * @m00 + a.m10 * @m01
    t_m01 = a.m01 * @m00 + a.m11 * @m01
    t_v0  = a.v0  * @m00 + a.v1  * @m01 + @v0
    @m00  = t_m00
    @m01  = t_m01
    @m10  = t_m10
    @m11  = t_m11
    @v0   = t_v0
    @v1   = t_v1

  leftComposeWith: (a) ->
    ###
    A.leftComposeWith(B)
    performs the composition A(B) and replaces A with the results
    ###
    t_m10 = @m00 * a.m10 + @m10 * a.m11
    t_m11 = @m01 * a.m10 + @m11 * a.m11
    t_v1  = @v0  * a.m10 + @v1  * a.m11 + a.v1
    t_m00 = @m00 * a.m00 + @m10 * a.m01
    t_m01 = @m01 * a.m00 + @m11 * a.m01
    t_v0  = @v0  * a.m00 + @v1  * a.m01 + a.v0
    @m00  = t_m00
    @m01  = t_m01
    @m10  = t_m10
    @m11  = t_m11
    @v0   = t_v0
    @v1   = t_v1

  getXScale:  -> Math.sqrt @m00 * @m00 + @m10 * @m10 
  getYScale:  -> Math.sqrt @m01 * @m01 + @m11 * @m11
  getXCenter: -> @v0
  getYCenter: -> @v1

class rotation extends affine2d
  constructor: (r) ->
    super Math.cos(r), -Math.sin(r), Math.sin(r), Math.cos(r), 0, 0

class scaling extends affine2d
  constructor: (sx, sy) -> super sx, 0, 0, sy, 0, 0

class translation extends affine2d
  constructor: (x, y) -> super 1, 0, 0, 1, x, y

class reflectionUnit extends affine2d
  # math for reflection borrowed from John H.
  # couldn't get the damn thing right, myself.
  constructor: (ux, uy) ->
    super 2.0 * ux * ux - 1.0, \
      2.0 * ux * uy, \
      2.0 * ux * uy, \
      2.0 * uy * uy - 1.0, \
      0.0, \
      0.0

class reflection extends reflectionUnit
  constructor: (r) ->
    super Math.cos r, Math.sin r

class flipX extends affine2d
  constructor: -> super -1, 0, 0, 1, 0, 0

class flipY extends affine2d
  constructor: -> super 1, 0, 0, -1, 0, 0

exports.affine2d        = affine2d
exports.rotation        = rotation
exports.scaling         = scaling
exports.translation     = translation
exports.reflectionUnit  = reflectionUnit
exports.reflection      = reflection
exports.flipX           = flipX
exports.flipY           = flipY


affine  = require '../src/affine'
polygon = require '../src/polygon'

#
# TODO: Put some good tests in here
#

rot_left  = new affine.rotation  Math.PI / 4
rot_right = new affine.rotation -Math.PI / 4
go_big    = new affine.scaling   2,   4
go_small  = new affine.scaling   0.5, 0.25


do_nothing = rot_left.copy()
do_nothing.rightComposeWith rot_right
do_nothing.rightComposeWith go_big
do_nothing.rightComposeWith go_small

square = polygon.factory.unitSquare()

console.log "1. Square before\n--------------"
console.log square

console.log "2. Square after \n--------------"
square.transform do_nothing
console.log square

Explanation
============
A small JS Library for doing affine transformations and (coming soon) other simple transformations
I need for a bigger project. `affine` and `polygon` are currently the two exports.


Node Use
=========
```
 npm install -g affine
```

Browser Use
===========

For your convenience, this project is stitched into one JS file, `affine.js`. The stitched file provides a way of requiring components. Here's an in-browser example:


Example Code
============

```html
<script src="affine.js"></script>
<script>
 var affine  = require('affine');
 var polygon = require('polygon');

 // let's define some affine transformations

 var rot_left  = new affine.rotation(  Math.PI / 4);
 var rot_right = new affine.rotation( -Math.PI / 4);
 var go_big    = new affine.scaling (  2,   4);
 var go_small  = new affine.scaling (  0.5, 0.25);

 // copy the original transform and compose with all these 
 var t = rot_left.copy();
 t.rightComposeWith(rot_right);
 t.rightComposeWith(go_big);
 t.rightComposeWith(go_small);

 // alternatively, we don't really need to make
 // all these new transforms; given one we can 
 // rotate, etc., it with convenience functions
 t.rotate(0.234);
 t.rotate(-0.234);
 t.scale(1,2);
 t.scale(1,0.5);

 // a transformation also has exposed functions,
 // so you don't have to explicitly make new
 // transforms 

 var square = polygon.factory.unitSquare();
 
 document.write("<h3>Square before</h3>");
 document.write(JSON.stringify(square));
 
 document.write("<h3>Square after (should be the same)</h3>");
 square.transform(t);
 document.write(JSON.stringify(square)); 

</script>
```


Usage (CoffeeScript example)
============================
```coffeescript
{affine, polygon} = require 'affine'

rot_left  = new affine.rotation  Math.PI / 4
rot_right = new affine.rotation -Math.PI / 4
go_big    = new affine.scaling   2,   4
go_small  = new affine.scaling   0.5, 0.25


# rightComposing a transform A with another, A'
# desctructively replaces A with A'(A)
t = rot_left.copy()
t.rightComposeWith rot_right
t.rightComposeWith go_big
t.rightComposeWith go_small
t.rotate 0.234
t.rotate -0.234
t.scale 1, 2
t.scale 1, 0.5
 
square = polygon.factory.unitSquare()
square.transform t

# square should be the same, as the 4 affines 
# cancel each other out.
console.log square
```


Contributing
============
All `.js` and `.json` files are auto-generated. Please edit the appropropriate `.coffee` files and run `cake build` before committing.

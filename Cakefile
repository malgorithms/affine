{spawn, exec} = require 'child_process'
fs            = require 'fs'
stitch        = require 'stitch'

task 'build', 'build the node module', (cb) ->
  console.log "Building"
  files = fs.readdirSync 'src'
  files = ('src/' + file for file in files when file.match(/\.coffee$/))
  clearLibJs ->
    runCoffee ['-c', '-o', 'lib/'].concat(files), ->
      stitchIt ->
        runCoffee ['-c', 'index.coffee'], ->
          console.log "Done building."
          cb() if typeof cb is 'function'

stitchIt = (cb) ->
  s = stitch.createPackage { paths: ['lib'] }
  s.compile (err, source) ->
    fs.writeFile 'affine.js', source, (err) ->
      if err then throw err
      console.log "Stitched."
      cb()

clearLibJs = (cb) ->
  files = fs.readdirSync 'lib'
  files = ("lib/#{file}" for file in files when file.match(/\.js$/))
  fs.unlinkSync f for f in files
  cb()

runCoffee = (args, cb) ->
  proc =         spawn 'coffee', args
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.on        'exit', (status) ->
    process.exit(1) if status != 0
    cb() if typeof cb is 'function'
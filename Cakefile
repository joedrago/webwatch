fs = require 'fs'
util = require 'util'

browserify = require 'browserify'
coffeeify = require 'coffeeify'
uglifyify = require 'uglifyify'

makeBundle = (forNode, productionBuild, mainCoffee, bundleFilename, callback) ->
  # equal of command line $ "browserify --debug -t coffeeify ./src/main.coffee > bundle.js "
  opts = {
    extensions: ['.coffee']
  }
  if forNode
    opts.builtins = []
    opts.detectGlobals = false
    opts.insertGlobals = false
    # opts.commondir = false
  if productionBuild
    buildName = "Production"
  else
    buildName = "Debug"
    opts.debug = true
  b = browserify opts
  b.add mainCoffee
  b.transform coffeeify
  # if productionBuild
  #   b.transform { global: true }, uglifyify
  b.bundle (err, result) ->
    if not err
      prepend = ""
      if forNode
        prepend = "#!/usr/bin/env node\n"
      fs.writeFile bundleFilename, prepend+result, (err) ->
        if not err
          util.log "Compilation finished (#{buildName}): #{bundleFilename}"
          callback?()
        else
          util.log "Bundle write failed: " + err
    else
      util.log "Compilation failed: " + err

task 'build', 'build (debug)', (options) ->
  makeBundle true, false, './src/main.coffee', "webwatch.js", ->

task 'prod', 'build (production)', (options) ->
  makeBundle true, true, './src/main.coffee', "webwatch.js", ->

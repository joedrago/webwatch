fs = require 'fs'
util = require 'util'

browserify = require 'browserify'
coffeeify = require 'coffeeify'
uglifyify = require 'uglifyify'

makeBundle = (forNode, mainCoffee, bundleFilename, callback) ->
  # equal of command line $ "browserify --debug -t coffeeify ./src/main.coffee > bundle.js "
  productionBuild = (process.env.NODE_ENV == 'production')
  opts = {
    extensions: ['.coffee']
  }
  if forNode
    opts.builtins = []
    opts.detectGlobals = false
    opts.insertGlobals = false
    # opts.commondir = false
  if not productionBuild
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
          util.log "Compilation finished: #{bundleFilename}"
          callback?()
        else
          util.log "Bundle write failed: " + err
    else
      util.log "Compilation failed: " + err

task 'build', 'build', (options) ->
  makeBundle true, './src/main.coffee', "webwatch.js", ->

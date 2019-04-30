AU = require('ansi_up').default
atomicWrite = require 'atomic-write'
getStdin = require 'get-stdin'

syntax = ->
  console.log "Syntax: webwatch [options] output.html"
  console.log "Options:"
  console.log "        -h,--help           This help output"
  console.log "        -n,--interval SEC   How often to refresh the web page"
  console.log ""
  process.exit(1)

main = ->
  args = require('minimist')(process.argv.slice(2), {
    boolean: ['h']
    string: ['n']
    alias:
      help: 'h'
      interval: 'n'
  })

  if args.help or args._.length < 1
    syntax()

  interval = 30
  if args.n
    interval = parseInt(args.n)

  au = new AU()
  rawOutput = await getStdin()
  htmlOutput = au.ansi_to_html(rawOutput)

  generatedTimestamp = new Date().toISOString()

  html = """
  <html>
  <head>
  <style>
    body {
      background-color: black;
      color: white;
    }
    .output {
      white-space: pre;
      font-family: monospace;
      font-size: 1.2em;
    }
    #timestamp {
      font-style: italic;
      color: #999999;
    }
  </style>
  <meta http-equiv="refresh" content="#{interval}">
  </head>
  <body>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
  <div class="output"><span id="timestamp"></span>

  #{htmlOutput}
  </output>
  <script>
      function fixTimestamps() {
        var generatedTimestamp = moment("#{generatedTimestamp}");
        document.getElementById('timestamp').innerHTML = "Updated " + generatedTimestamp.fromNow() + " (" + generatedTimestamp.format('MMMM Do YYYY, h:mm:ss a') + ")";
      }

      fixTimestamps();
      window.setInterval(function() {
        fixTimestamps();
      }, 1000);
  </script>
  </body>
  </html>
  """

  outputFilename = args._[0]
  atomicWrite.writeFile outputFilename, html, (err) ->
    if err
      console.log err
    else
      console.log "Wrote: #{outputFilename}"

main()

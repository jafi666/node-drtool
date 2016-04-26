#Express app
express = require 'express'
config = require './config/config'
expressConfig = require './config/express'

app = express()

server = app.listen config.port
#server.on 'error', onError
#server.on 'listening', onListening

expressConfig app, config


###
  Event listener for HTTP server "error" event.
###
onError = (error) ->
  if error.syscall isnt 'listen'
    throw error

  bind = typeof port == 'string' ? 'Pipe ' + port : 'Port ' + port

  # handle specific listen errors with friendly messages
  switch error.code
    when 'EACCES'
      console.error bind + ' requires elevated privileges'
      process.exit 1
      break
    when 'EADDRINUSE'
      console.error bind + ' is already in use'
      process.exit 1
      break
    else
      throw error;


###
  Event listener for HTTP server "listening" event.
###
onListening = () ->
  addr = server.address()
  bind = typeof addr == 'string' ? 'pipe ' + addr : 'port ' + addr.port
  debug 'Listening on ' + bind

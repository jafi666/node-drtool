#node modules
express = require 'express'
logger = require 'morgan'
favicon = require 'serve-favicon'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
compress = require 'compression'
methodOverride = require 'method-override'

#own modules
Routes = require '../app/app'

#constants
BOWER_COMPONENT = '/bower_components'
VIEWS = '/build/client'

###
Express configuration.
@param app [Express] an instance of express app.
@param app [Object] basic server configuration.
###
module.exports = (app, config) ->

  app.set 'views', "#{config.root}#{VIEWS}"

  app.engine 'html', (require 'ejs').renderFile
  app.set 'view engine', 'html'

  app.use logger 'dev'
  app.use bodyParser.json()
  app.use bodyParser.urlencoded(
    extended: true
  )
  app.use cookieParser()
  app.use compress()

  app.use express.static "#{config.root}#{VIEWS}"

  app.use BOWER_COMPONENT, express.static "#{config.root}#{BOWER_COMPONENT}"

  app.use methodOverride()

  # Load routes.
  Routes app, express

  # catch 404 and forward to error handler.
  app.use (req, res, next) ->
    err = new Error 'Page Not Found'
    err.status = 404
    next err

  ###
  development error handler will print stacktrace.
  ###
  if app.get('env') == 'development'
    app.use (err, req, res, next) ->
      res.status err.status || 500
      console.error err.stack
      res.json {'error': err.message}

  ###
  production error handler no stacktraces leaked to user.
  ###
  app.use (err, req, res, next) ->
    res.status err.status || 500
    res.json {'error': err.message}

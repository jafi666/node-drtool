# node modules
Q = require 'q'

# own modules
ActionManager = require './action-manager'

###

###
class TodoAction extends ActionManager
  ###

  ###
  constructor: ->
    super 'Todo'

module.exports = TodoAction
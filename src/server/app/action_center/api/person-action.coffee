# node modules
Q = require 'q'

# own modules
ActionManager = require './action-manager'

###
People class, manages all information regarding people
###
class PersonAction extends ActionManager
  ###
  Constructor, initializes mode on ActionManager
  ###
  constructor: ->
    super 'Person'

module.exports = PersonAction